Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2GWXjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:39:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61649 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2GWXjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:39:17 -0400
MIME-Version: 1.0
Date: Tue, 24 Jul 2012 07:39:16 +0800
Message-ID: <CA+qZnSRNAAN6erat3Umuk6U9VYuc5SiQYK6PL8bHYAOcQ+SnAw@mail.gmail.com>
Subject: Suse 11 SP1 kernel panic on HP hardware
From: tingwei liu <tingw.liu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suse 11 SP1 kernel panic。

I can't debug it without debuginfo. Who can give me a link of sels
2.6.32.12-0.7.default.debug or give some advise.

Thanks for any reply!

kernel: [3077010.856280] BUG: unable to handle kernel NULL pointer
dereference at 0000000000000008
kernel: [3077010.856291] IP: [<ffffffff81046958>] find_busiest_group+0x348/0x8b0
kernel: [3077010.856302] PGD a46ac067 PUD 8c828067 PMD 0
kernel: [3077010.856307] Oops: 0000 [#1] SMP
kernel: [3077010.856312] last sysfs file:
/sys/devices/system/cpu/cpu23/cache/index2/shared_cpu_map
kernel: [3077010.856318] CPU 19
kernel: [3077010.856320] Modules linked in: bluetooth rfkill af_packet
drbd iptable_filter ip_tables x_tables nfs lockd fscache nfs_acl
auth_rpcgss sunrpc ipv6 cpufreq_conservative cpufreq_userspace
cpufreq_powersave pcc_cpufreq fuse loop dm_mod tpm_tis tpm tpm_bios
bnx2 e1000e iTCO_wdt rtc_cmos serio_raw rtc_core hpilo pcspkr
iTCO_vendor_support rtc_lib hpwdt joydev power_meter button container
usbhid hid uhci_hcd ehci_hcd usbcore edd ext3 mbcache jbd fan
processor hpsa cciss scsi_mod thermal thermal_sys hwmon
kernel: [3077010.856370] Supported: Yes
kernel: [3077010.856375] Pid: 5762, comm: program_t Not tainted
2.6.32.12-0.7-default #1 ProLiant DL380 G7
kernel: [3077010.856379] RIP: 0010:[<ffffffff81046958>]
[<ffffffff81046958>] find_busiest_group+0x348/0x8b0
kernel: [3077010.856387] RSP: 0018:ffff880112f59ab8  EFLAGS: 00010006
kernel: [3077010.856391] RAX: 00000000009da550 RBX: ffff880123c0ebc0
RCX: 0000000000000000
kernel: [3077010.856395] RDX: 0000000100000000 RSI: 0000000000000020
RDI: 0000000000000000
kernel: [3077010.856399] RBP: ffff880112f59c28 R08: 0000000000000020
R09: ffff880123c0ebd0
kernel: [3077010.856404] R10: 0000000000000000 R11: 0000000100000000
R12: 0000000000000000
kernel: [3077010.856408] R13: 0000000100000000 R14: 0000000000000000
R15: ffff880123c0ebd0
kernel: [3077010.856413] FS:  00007fc35fbac710(0000)
GS:ffff880123d20000(0000) knlGS:0000000000000000
kernel: [3077010.856417] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [3077010.856421] CR2: 0000000000000008 CR3: 0000000018124000
CR4: 00000000000006e0
kernel: [3077010.856426] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
kernel: [3077010.856430] DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
kernel: [3077010.856434] Process program_t (pid: 5762, threadinfo
ffff880012f58000, task ffff88000db421c0)
kernel: [3077010.856438] Stack:
kernel: [3077010.856441]  0000000000000000 0000000000000000
0000000000000000 0000000000000000
kernel: [3077010.856445] <0> 0000000000000000 0000000000000000
0000000000000000 0000000000000000
kernel: [3077010.856450] <0> 0000000000000000 0000000000000000
0000000000000000 0000000000000000
kernel: [3077010.856457] Call Trace:
kernel: [3077010.856467] Inexact backtrace:
kernel: [3077010.856468]
kernel: [3077010.856472] Code: 74 10 48 8b 75 10 44 8b 2e 45 85 ed 0f
84 a3 02 00 00 48 8b 95 00 ff ff ff 44 8b a5 f8 fe ff ff 48 8b 45 a8
48 01 85 20 ff ff ff <8b> 42 08 48 01 85 28 ff ff ff 45 85 e4
74 14 48 8b 45 c0 ba 01
