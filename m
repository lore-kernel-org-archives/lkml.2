Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2HPAEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:04:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64660 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2HPAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:04:13 -0400
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
Date: Wed, 15 Aug 2012 20:04:12 -0400
Message-ID: <CAO9zADxc3fVUwRhxzbirQvjVLjun3_Dt150KYakoCUOzB3aksg@mail.gmail.com>
Subject: 3.5.1: WARNING: at include/linux/iocontext.h:140 copy_process.part.56+0x1041/0x1190()
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel: 3.5.1 x86_64
Just FYI, this may have been due to an NFS issue (remote host turned
off during dump possibly) but reporting just incase:

[41793.725267] ------------[ cut here ]------------
[41793.725273] WARNING: at include/linux/iocontext.h:140
copy_process.part.56+0x1041/0x1190()
[41793.725274] Hardware name: X9SCL/X9SCM
[41793.725276] Pid: 20378, comm: dump Not tainted 3.5.1 #2
[41793.725276] Call Trace:
[41793.725279]  [<ffffffff8102f0d5>] warn_slowpath_common+0x75/0xb0
[41793.725280]  [<ffffffff8102f1e5>] warn_slowpath_null+0x15/0x20
[41793.725282]  [<ffffffff8102e371>] copy_process.part.56+0x1041/0x1190
[41793.725283]  [<ffffffff8102e62b>] do_fork+0x13b/0x2f0
[41793.725285]  [<ffffffff8103cc02>] ? recalc_sigpending+0x12/0x30
[41793.725287]  [<ffffffff8103f4aa>] ? __set_current_blocked+0x3a/0x60
[41793.725290]  [<ffffffff8100a1e3>] sys_clone+0x23/0x30
[41793.725293]  [<ffffffff815c0a33>] stub_clone+0x13/0x20
[41793.725294]  [<ffffffff815c07e6>] ? system_call_fastpath+0x1a/0x1f
[41793.725295] ---[ end trace 6afd1df8f82f60e4 ]---

Justin.
