Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab1GYGN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 02:13:59 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52671 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1GYGNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 02:13:54 -0400
MIME-Version: 1.0
Date: Mon, 25 Jul 2011 14:13:53 +0800
Message-ID: <CAD+1EGNiUMhrbH6cWXKXEN5hWagiUcGCXb1E9Z_knCbKrniXbA@mail.gmail.com>
Subject: [RFC]nbd-client connect error
From: harryxiyou <harryxiyou@gmail.com>
To: wouter@debian.org
Cc: hua kang <xiyoucloud@gmail.com>, linux-kernel@vger.kernel.org,
        linux-kernel@zh-kernel.org,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?5a2U5bu65Yab?= <kongjianjun@gmail.com>, pavel@ucw.cz,
        Paul.Clements@steeleye.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
When i use ndb-server and nbd-client tools, something wrong(maybe a
bug) happens to like following.

Server: (IP: 192.168.1.103)
# uname -a
Linux wangzhe-laptop 2.6.32-33-generic #68-Ubuntu SMP Fri Jun 17
16:25:19 UTC 2011 i686 GNU/Linux

# cat /usr/etc/nbd-server/config
[generic]
[export]
exportname = /root/1.c
port = 2001

# nbd-server

Client: (IP: 192.168.1.30)

# uname -a
Linux localhost.localdomain 2.6.18-238.12.1.el5 #1 SMP Tue May 31
13:23:01 EDT 2011 i686 i686 i386 GNU/Linux

# nbd-client 192.168.1.103 2001 /dev/nbd0
Negotiation: ..size = 0MB
Error: Ioctl/1.1a failed: Inappropriate ioctl for device

Exiting.

# nbd-client 192.168.1.103 2001 /dev/sda1
Negotiation: ..size = 0MB
Error: Ioctl/1.1a failed: Invalid argument

Exiting.


I suspect the client machine's kernel version is too low to run the
command nbd-client.
Maybe the same problem with server machine. Could anyone give me some
suggestions?


Thanks in advance
Harry Wei
