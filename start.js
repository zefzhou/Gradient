// 1. 从文件读取代理列表
const fs = require('fs')
const path = require('path')
require('console-stamp')(console, {
  format: ':date(yyyy/mm/dd HH:MM:ss.l)'
})


let configFile = "config.txt";

try {
  proxies = fs.readFileSync(path.resolve(__dirname, configFile), 'utf-8').split('\n').filter(Boolean)
} catch (error) {
  console.log('-> 未找到 config.txt 文件或读取出错，将不使用代理启动应用...')
}


// 2. 使用 PROXY 环境变量启动 pm2
const { execSync } = require('child_process')



function readConfig(file) {
  if (!fs.existsSync(file)) {
    console.log(`文件 ${file} 不存在`);
    return [];
  }

  const data = fs.readFileSync(file, 'utf-8');

  const lines = data.split('\n');

  const result = [];

  lines.forEach(line => {
    let segs = line.split(';');
    if (segs.length < 2) {
      throw new Error('配置格式不正确');
    }
    let email = segs[0];
    let password = segs[1];
    let proxy = '';
    if (segs.length > 2) {
      proxy = segs[2];
    }
    if (email && password) {
      result.push({ email, password, proxy });
    }
  });

  return result;
}


// 3.读取配置 启动
let configs = readConfig(configFile)


let noProxyIdx = 0;
let proxyIdx = 0;

for (let index = 0; index < configs.length; index++) {
  const config = configs[index];

  console.log(`email = ${config.email}, password = ${config.password}, proxy = ${config.proxy}`)

  if (config.proxy == '') {
    console.error(`${config.email} 未设置代理, 不使用代理启动应用...`)
    const name = `gradient-bot-no-proxy-${noProxyIdx++}`;
    execSync(`APP_USER='${config.email}' APP_PASS='${config.password}' pm2 start app.js --name ${name} -l ${name}.log`)
    console.log(`-> ✓ 已无代理启动 ${name}`)
  } else {
    const name = `gradient-${proxyIdx++}`
    execSync(`PROXY=${config.proxy} APP_USER='${config.email}' APP_PASS='${config.password}' pm2 start app.js --name ${name} -l ${name}.log`)
    console.log(`-> ✓ 已使用代理启动 ${name}`)
  }
}


// 4. 显示 pm2 状态
execSync('pm2 status')
