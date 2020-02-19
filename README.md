# 以 REPL 模式启动 EFB

REPL 模式同样需要配置 EFB。可以在第一次运行 EFB 的使用，主要用来进入维护模式，比如：绑定公众号到某一个 Group。

```bash
$ docker run -d --name efbv2 $(pwd):/root/.ehforwarderbot/profiles/default/ scavin/docker-efbv2:REPL
```

## 以 REPL 模式启动 EFB

```bash
$ docker exec -it efbv2 ash
```

来源在[这里](https://github.com/blueset/efb-wechat-slave/wiki/EWS-&-ETM%EF%BC%9A%E6%89%B9%E9%87%8F%E7%BB%91%E5%AE%9A%EF%BC%88%E5%85%AC%E4%BC%97%E5%8F%B7%E7%AD%89%EF%BC%89)，但注意这里有一些错误，以下面的为准：


EWS & ETM：批量绑定（公众号等）
Eana Hufwe edited this page on 25 Nov 2018 · 2 revisions
Written for EFB 2.0.0b10; ETM 2.0.0b11; EWS 2.0.0a12

注意：
本内容是一个非正式支持的 Hack，且未经过测试。项目维护者及作者没有义务对下述内容提供任何支持，且不对该内容产生的任何后果负任何责任。 请在充分理解下述内容原理的前提下操作。You have been warned.

将 ETM 的 Telegram Bot 添加到目标绑定群组、发送 /info 以获取该群组 ID。群组 ID 应是一个负整数。下面以 -3324225 为例。
在当前的 profile 中设置 ETM 为主端，并启用 EWS。
以 REPL 模式启动 EFB
python3 -i -m ehforwarderbot [-p PROFILE_NAME]
操作 REPL

```python
>>> from ehforwarderbot import coordinator
>>> from efb_telegram_master import utils
>>> # 获取 ETM, EWS 运行实例
>>> etm = coordinator.master
>>> ews = coordinator.slaves['blueset.wechat']  # 如有运行多个实例，需追加实例 ID
>>> # 获取会话列表
>>> chats = ews.get_chats()
>>> # 提取出所有需要批量绑定的会话，例如这里要提取所有非公众号
>>> # 具体可使用的参数请参考 EFB 和 EWS 的说明文档
>>> to_link = [i.uid for i in chats if i.vendor_specific.get('is_mp', False)]
>>> # 绑定到指定会话
>>> tg_grp_id = -123456
>>> for i in to_link:
...     etm.db.add_chat_assoc(master_uid=utils.chat_id_to_str(etm.channel_id, tg_grp_id),
...                           slave_uid=utils.chat_id_to_str(ews.channel_id, i),
...                           multiple_slave=True)
>>> # 退出 EFB 实例并以一般方式重新启动
>>> ^D
```
