Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1EKP6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:58:00 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:51413 "EHLO zfrontend1.aha.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1EKP54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:57:56 -0400
X-iZenGuard: ZMAIL
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc7-git1 boot error message (no crash)
To: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Wed, 11 May 2011 11:57:53 -0400
Message-ID: <web-521385144@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often vger.kernel.org refuses my mails (see below), so 
that I send my information (see below) now to some persons


wl


===============
From: <MAILER-DAEMON@aha.ru>
Subject: WARNING. Mail Delayed: 2.6.39-rc7-git1 boot error 
message (no crash)
Date: Wed, 11 May 2011 12:58:22 +0400
To: <w.landgraf@ru.ru>
	Full Headers
Undecoded Letter
This is a warning message only.
   Your message remains in the server queue,
   the server will try to send it again.
   You should not try to resend your message now.


Message delivery to 'linux-kernel@vger.kernel.org' delayed
SMTP module(domain vger.kernel.org) reports:
  vger.kernel.org:451 4.7.1 Hello [195.2.83.148], for 
recipient address <linux-kernel@vger.kernel.org> the 
policy analysis reported: zpostgrey: connect: Connection 
refused

Reporting-MTA:	dns; zfrontend2.aha.ru
Original-Recipient:	rfc822;<linux-kernel@vger.kernel.org>
Final-Recipient:	rfc822;<linux-kernel@vger.kernel.org>
Action:	delayed
Status:	4.0.0

From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc7-git1 boot error message (no crash)
Date: Wed, 11 May 2011 00:58:11 -0400
To: linux-kernel@vger.kernel.org

===================================



From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc7-git1 boot error message (no crash)
Date: Wed, 11 May 2011 00:58:11 -0400
To: linux-kernel@vger.kernel.org
	Full Headers
Undecoded Letter
Below an error message during boot, on a Qosmio Toshiba 
Laptop of a neighbour, no crash and normal working. On a 
Packard-Bell laptop of another person, nor on my own 
computer, occurs this error message.

Probably not important.

For avaliation / check / correction.


W.Landgraf


================
May 11 01:01:46 localhost kernel: ------------[ cut here 
]------------
May 11 01:01:46 localhost kernel: WARNING: at 
fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
May 11 01:01:46 localhost kernel: Hardware name: Qosmio 
E10
May 11 01:01:46 localhost kernel: sysfs: cannot create 
duplicate filename 
'/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
May 11 01:01:46 localhost kernel: Modules linked in:
May 11 01:01:46 localhost kernel: Pid: 1, comm: swapper 
Not tainted 2.6.39-rc7-git1-i486-1sys #1
May 11 01:01:46 localhost kernel: Call Trace:
May 11 01:01:46 localhost kernel: [<c112d5e2>] ? 
sysfs_add_one+0x83/0x95
May 11 01:01:46 localhost kernel: [<c1040e25>] 
warn_slowpath_common+0x7a/0x8f
May 11 01:01:46 localhost kernel: [<c112d5e2>] ? 
sysfs_add_one+0x83/0x95
May 11 01:01:46 localhost kernel: [<c1040ec5>] 
warn_slowpath_fmt+0x33/0x35
May 11 01:01:46 localhost kernel: [<c112d5e2>] 
sysfs_add_one+0x83/0x95
May 11 01:01:46 localhost kernel: [<c112cfd8>] 
sysfs_add_file_mode+0x4a/0x72
May 11 01:01:46 localhost kernel: [<c112d018>] 
sysfs_add_file+0x18/0x1c
May 11 01:01:46 localhost kernel: [<c112d0b3>] 
sysfs_create_file+0x25/0x27
May 11 01:01:46 localhost kernel: [<c1792ac8>] 
device_create_file+0x18/0x1a
May 11 01:01:46 localhost kernel: [<c1693b3a>] 
create_regulator+0xd8/0x21d
May 11 01:01:46 localhost kernel: [<c1693dde>] 
_regulator_get+0x15f/0x1ba
May 11 01:01:46 localhost kernel: [<c1693e5c>] 
regulator_get+0xf/0x11
May 11 01:01:46 localhost kernel: [<c1cd492d>] 
sdhci_add_host+0x586/0x6d1
May 11 01:01:46 localhost kernel: [<c15945ab>] ? 
pci_ioremap_bar+0x5b/0x60
May 11 01:01:46 localhost kernel: [<c1eb3c28>] 
sdhci_pci_probe_slot+0x1c1/0x204
May 11 01:01:46 localhost kernel: [<c1eb3d71>] ? 
sdhci_pci_probe+0x106/0x1cd
May 11 01:01:46 localhost kernel: [<c1eb3dd9>] 
sdhci_pci_probe+0x16e/0x1cd
May 11 01:01:46 localhost kernel: [<c15947dd>] 
local_pci_probe+0x41/0x85
May 11 01:01:46 localhost kernel: [<c1595352>] 
pci_device_probe+0x48/0x6b
May 11 01:01:46 localhost kernel: [<c1794899>] 
really_probe+0x7f/0x11c
May 11 01:01:46 localhost kernel: [<c179b256>] ? 
pm_runtime_barrier+0x4d/0x79
May 11 01:01:46 localhost kernel: [<c1794967>] 
driver_probe_device+0x31/0x46
May 11 01:01:46 localhost kernel: [<c17949c4>] 
__driver_attach+0x48/0x64
May 11 01:01:46 localhost kernel: [<c17941f6>] 
bus_for_each_dev+0x42/0x6c
May 11 01:01:46 localhost kernel: [<c179473f>] 
driver_attach+0x1e/0x20
May 11 01:01:46 localhost kernel: [<c179497c>] ? 
driver_probe_device+0x46/0x46
May 11 01:01:46 localhost kernel: [<c1793c0b>] 
bus_add_driver+0xc6/0x20a
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c1794eef>] 
driver_register+0x98/0xf8
May 11 01:01:46 localhost kernel: [<c1794eef>] ? 
driver_register+0x98/0xf8
May 11 01:01:46 localhost kernel: [<c1695525>] ? 
tty_register_driver+0x15e/0x1e2
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c1595541>] 
__pci_register_driver+0x3d/0x96
May 11 01:01:46 localhost kernel: [<c1ec9c37>] ? 
printk+0x1d/0x1f
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c24ba7de>] 
sdhci_drv_init+0x14/0x16
May 11 01:01:46 localhost kernel: [<c1001174>] 
do_one_initcall+0x8c/0x142
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c1082dfc>] ? 
irq_to_desc+0x8/0x1e
May 11 01:01:46 localhost kernel: [<c24ba7ca>] ? 
sdhci_drv_init+0x22/0x22
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c245b293>] 
kernel_init+0x96/0x12a
May 11 01:01:46 localhost kernel: [<c1ecd4c6>] 
kernel_thread_helper+0x6/0x10
May 11 01:01:46 localhost kernel: ---[ end trace 
acbbad639e5c6e5b ]---
May 11 01:01:46 localhost kernel: create_regulator: dummy: 
could not add regulator_dev requested microamps sysfs 
entry
May 11 01:01:46 localhost kernel: _regulator_get: 
0000:02:0b.4 supply vmmc not found, using dummy regulator
May 11 01:01:46 localhost kernel: ------------[ cut here 
]------------
May 11 01:01:46 localhost kernel: WARNING: at 
fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
May 11 01:01:46 localhost kernel: Hardware name: Qosmio 
E10
May 11 01:01:46 localhost kernel: sysfs: cannot create 
duplicate filename 
'/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
May 11 01:01:46 localhost kernel: Modules linked in:
May 11 01:01:46 localhost kernel: Pid: 1, comm: swapper 
Tainted: G W 2.6.39-rc7-git1-i486-1sys #1
May 11 01:01:46 localhost kernel: Call Trace:
May 11 01:01:46 localhost kernel: [<c112d5e2>] ? 
sysfs_add_one+0x83/0x95
May 11 01:01:46 localhost kernel: [<c1040e25>] 
warn_slowpath_common+0x7a/0x8f
May 11 01:01:46 localhost kernel: [<c112d5e2>] ? 
sysfs_add_one+0x83/0x95
May 11 01:01:46 localhost kernel: [<c1040ec5>] 
warn_slowpath_fmt+0x33/0x35
May 11 01:01:46 localhost kernel: [<c112d5e2>] 
sysfs_add_one+0x83/0x95
May 11 01:01:46 localhost kernel: [<c112cfd8>] 
sysfs_add_file_mode+0x4a/0x72
May 11 01:01:46 localhost kernel: [<c112d018>] 
sysfs_add_file+0x18/0x1c
May 11 01:01:46 localhost kernel: [<c112d0b3>] 
sysfs_create_file+0x25/0x27
May 11 01:01:46 localhost kernel: [<c1792ac8>] 
device_create_file+0x18/0x1a
May 11 01:01:46 localhost kernel: [<c1693b3a>] 
create_regulator+0xd8/0x21d
May 11 01:01:46 localhost kernel: [<c1693dde>] 
_regulator_get+0x15f/0x1ba
May 11 01:01:46 localhost kernel: [<c1693e5c>] 
regulator_get+0xf/0x11
May 11 01:01:46 localhost kernel: [<c1cd492d>] 
sdhci_add_host+0x586/0x6d1
May 11 01:01:46 localhost kernel: [<c15945ab>] ? 
pci_ioremap_bar+0x5b/0x60
May 11 01:01:46 localhost kernel: [<c1eb3c28>] 
sdhci_pci_probe_slot+0x1c1/0x204
May 11 01:01:46 localhost kernel: [<c1eb3d71>] ? 
sdhci_pci_probe+0x106/0x1cd
May 11 01:01:46 localhost kernel: [<c1eb3dd9>] 
sdhci_pci_probe+0x16e/0x1cd
May 11 01:01:46 localhost kernel: [<c15947dd>] 
local_pci_probe+0x41/0x85
May 11 01:01:46 localhost kernel: [<c1595352>] 
pci_device_probe+0x48/0x6b
May 11 01:01:46 localhost kernel: [<c1794899>] 
really_probe+0x7f/0x11c
May 11 01:01:46 localhost kernel: [<c179b256>] ? 
pm_runtime_barrier+0x4d/0x79
May 11 01:01:46 localhost kernel: [<c1794967>] 
driver_probe_device+0x31/0x46
May 11 01:01:46 localhost kernel: [<c17949c4>] 
__driver_attach+0x48/0x64
May 11 01:01:46 localhost kernel: [<c17941f6>] 
bus_for_each_dev+0x42/0x6c
May 11 01:01:46 localhost kernel: [<c179473f>] 
driver_attach+0x1e/0x20
May 11 01:01:46 localhost kernel: [<c179497c>] ? 
driver_probe_device+0x46/0x46
May 11 01:01:46 localhost kernel: [<c1793c0b>] 
bus_add_driver+0xc6/0x20a
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c1794eef>] 
driver_register+0x98/0xf8
May 11 01:01:46 localhost kernel: [<c1794eef>] ? 
driver_register+0x98/0xf8
May 11 01:01:46 localhost kernel: [<c1695525>] ? 
tty_register_driver+0x15e/0x1e2
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c1595541>] 
__pci_register_driver+0x3d/0x96
May 11 01:01:46 localhost kernel: [<c1ec9c37>] ? 
printk+0x1d/0x1f
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c24ba7de>] 
sdhci_drv_init+0x14/0x16
May 11 01:01:46 localhost kernel: [<c1001174>] 
do_one_initcall+0x8c/0x142
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c1082dfc>] ? 
irq_to_desc+0x8/0x1e
May 11 01:01:46 localhost kernel: [<c24ba7ca>] ? 
sdhci_drv_init+0x22/0x22
May 11 01:01:46 localhost kernel: [<c245b1fd>] ? 
parse_early_options+0x25/0x25
May 11 01:01:46 localhost kernel: [<c245b293>] 
kernel_init+0x96/0x12a
May 11 01:01:46 localhost kernel: [<c1ecd4c6>] 
kernel_thread_helper+0x6/0x10
May 11 01:01:46 localhost kernel: ---[ end trace 
acbbad639e5c6e5c ]---
May 11 01:01:46 localhost kernel: create_regulator: dummy: 
could not add regulator_dev requested microamps sysfs 
entry
---
---
Professional hosting for everyone - http://www.host.ru

