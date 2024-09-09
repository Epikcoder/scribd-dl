// Just additional code for https://github.com/rkwyu/scribd-dl

import { exec } from 'child_process';
import { promisify } from 'util';
import cors from 'cors'
import express from 'express'
import { config } from 'dotenv'
config()
import path from 'path';
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const execPromise = promisify(exec);

async function executeCommand(command) {
    try {
        const { stdout, stderr } = await execPromise(command);
        if (stderr) {
            throw new Error(`Stderr: ${stderr}`);
        }

        return stdout;
    } catch (error) {
        throw new Error(`Error executing command: ${error.message}`);
    }
}

function checkIfGenerated(output) {
    const logs = output.trim().split('\n');
    const lastLog = logs[logs.length - 1];
    if (lastLog.includes('Generated: ')) {
        return { result: true, path: lastLog.split(" output/")[1] }
    } else {
        return { result: false, path: "" }
    }
}

async function main(url) {
    return new Promise(async (resolve, reject) => {
        try {
            const command = `npm start '${url}'`;
            const output = await executeCommand(command);
            resolve(checkIfGenerated(output));
        } catch (error) {
            if (error.toString().includes("Unsupported UR")) {
                reject({result: false, error: "Not supported URL" })
            } else {
                reject({result: false, error: error })
            }
        }
    })

}

const app = express()
app.use(cors())

app.get("/", (req, res) => {
    res.send("/down?url=<scribd>")
})

app.all("/down", async (req, res) => {
    const browserStartAttempts = 5;
    let a;
    for (let i = 0; i < browserStartAttempts; i++) {
        try {
            const { url } = req.query;
            if (!url) return res.json({ result: false, error: "invalid url/nourl" })
            return res.json(await main(url))
        } catch (e) {
            a = e
            console.log(e)
            // return res.json(e)
        }
    }
    
    return res.json({result: false, error:  typeof a == "object"
        ? { message: a.message, stack: a.stack, name: a.name }
        : a.toString(),})

})
app.use(express.static(path.join(__dirname, 'output')));

const port = process.env.SERVER_PORT || 7860
app.listen(port, () => {
    console.log("listening on port: " + port)
})

// await main(`https://www.scribd.com/doc/252120132/Rangkaian-Alarm-Anti-Maling`);