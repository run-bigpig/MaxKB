-- 创建数据库（如果不存在）
CREATE DATABASE "kgai" IF NOT EXISTS;

-- 连接到数据库
\c "kgai";

-- 创建扩展（如果不存在）
CREATE EXTENSION "vector" IF NOT EXISTS;