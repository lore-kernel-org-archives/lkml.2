Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab1D2WKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:10:21 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:38704 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932333Ab1D2WKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:10:20 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc5-git2 boot crashs
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 29 Apr 2011 18:10:14 -0400
Message-ID: <web-515866242@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Pid: 5635, comm: mount Tainted: G         C 
 2.6.39-rc5-git2 #1 System manufacturer System Product 
Name/M2N8-VMX
EIP: 0060:[<c12d01fb>] EFLAGS: 00010246 CPU: 0
EIP is at logfs_drop_inode+0x3c/0x68
EAX: 00000000 EBX: f4db8000 ECX: f4db81f4 EDX: f4db81f4
ESI: f521c000 EDI: f5232c00 EBP: f5199e70 ESP: f5199e68
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process mount (pid: 5635, ti=f5198000 task=f523ae50 
task.ti=f5198000)
Stack:
  c1f2344c f4db8000 f5199e84 c10ea544 ffffffea f5232c00 
f68ac1c0 f5199ec0
  c12d77cd 00000000 00000000 c10ced5c 00000000 f521c000 
00000400 f521c000
  f68a4b40 00000040 000000d0 00000000 f5106cb0 f5106cb0 
f5199ef8 c10d9b11
Call Trace:
  [<c10ea544>] iput+0x5c/0x119
  [<c12d77cd>] logfs_mount+0x44f/0x5cc
  [<c10ced5c>] ? __kmalloc_track_caller+0x9b/0x157
  [<c10d9b11>] mount_fs+0x68/0x13e
  [<c10b1ce3>] ? kstrdup+0x30/0x41
  [<c10ee6c3>] vfs_kern_mount+0x53/0x7f
  [<c10ee747>] do_kern_mount+0x3c/0xbb
  [<c10eede8>] do_mount+0x622/0x66f
  [<c10ed9ca>] ? copy_mount_options+0xe/0xe7
  [<c10b1c15>] ? memdup_user+0x34/0x4b
  [<c10b1c5d>] ? strndup_user+0x31/0x42
  [<c10eeea2>] sys_mount+0x6d/0x9b
  [<c1eba70c>] syscall_call+0x7/0xb
Code: 8c 01 00 00 b8 30 4e 79 c2 e8 41 a1 be 00 8d 8b f4 
01 00 00 8b 93 f4 01 00 00 8b 83 f8 01 00 00 89 42 04 89 
10 8b 86 54 02 00 00
  48 04 89 83 f4 01 00 00 8d 86 54 02 00 00 89 83 f8 01 00 
00
EIP: [<c12d01fb>] logfs_drop_inode+0x3c/0x68 SS:ESP 
0068:f5199e68
CR2: 0000000000000004
---[ end trace cd59ca17c20fba5d ]---
---
Professional hosting for everyone - http://www.host.ru
