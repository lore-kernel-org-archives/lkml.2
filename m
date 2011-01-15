Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1AOOM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:12:58 -0500
Received: from lucidpixels.com ([75.144.35.66]:38702 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1AOOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:12:58 -0500
Date: Sat, 15 Jan 2011 09:12:57 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Subject: Root dentry has weird name <>: WARNING: at fs/dcache.c:1984
 prepend_path+0x165/0x170()
Message-ID: <alpine.DEB.2.00.1101150911350.18258@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel 2.6.37, Debian testing:

[393346.970951] ------------[ cut here ]------------
[393346.970957] WARNING: at fs/dcache.c:1984 prepend_path+0x165/0x170()
[393346.970958] Hardware name: 
[393346.970959] Root dentry has weird name <>
[393346.970960] Modules linked in:
[393346.970962] Pid: 844, comm: chrome-sandbox Not tainted 2.6.37 #2
[393346.970964] Call Trace:
[393346.970968]  [<ffffffff8103307b>] ? warn_slowpath_common+0x7b/0xc0
[393346.970970]  [<ffffffff81033175>] ? warn_slowpath_fmt+0x45/0x50
[393346.970973]  [<ffffffff810b79f5>] ? prepend_path+0x165/0x170
[393346.970975]  [<ffffffff810b7cbf>] ? d_path+0xcf/0x100
[393346.970978]  [<ffffffff810e9c5c>] ? proc_pid_readlink+0x8c/0xe0
[393346.970981]  [<ffffffff810a8969>] ? sys_readlinkat+0x79/0xb0
[393346.970983]  [<ffffffff810022bb>] ? system_call_fastpath+0x16/0x1b
[393346.970985] ---[ end trace c6de02a53f3a3138 ]---
[393346.971128] ------------[ cut here ]------------
[393346.971130] WARNING: at fs/dcache.c:1984 prepend_path+0x165/0x170()
[393346.971131] Hardware name: 
[393346.971132] Root dentry has weird name <>
[393346.971133] Modules linked in:
[393346.971134] Pid: 844, comm: chrome-sandbox Tainted: G        W   2.6.37 #2
[393346.971136] Call Trace:
[393346.971138]  [<ffffffff8103307b>] ? warn_slowpath_common+0x7b/0xc0
[393346.971140]  [<ffffffff81033175>] ? warn_slowpath_fmt+0x45/0x50
[393346.971142]  [<ffffffff810b79f5>] ? prepend_path+0x165/0x170
[393346.971144]  [<ffffffff810b7cbf>] ? d_path+0xcf/0x100
[393346.971146]  [<ffffffff810e9c5c>] ? proc_pid_readlink+0x8c/0xe0
[393346.971149]  [<ffffffff810a8969>] ? sys_readlinkat+0x79/0xb0
[393346.971150]  [<ffffffff810022bb>] ? system_call_fastpath+0x16/0x1b
[393346.971152] ---[ end trace c6de02a53f3a3139 ]---

Justin.

