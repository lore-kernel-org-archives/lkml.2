Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0DNPND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:13:03 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62390 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab0DNPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nKmrQ5Ltg+NXelusXK5R8xktKEhpusi7oCzvois3oBThNmMZS5TWmPPMYWSVOGDG6/
         p/bgL9M8SYx7HroqzjdO7t4NEGs1thBFiP4cntv6pqxEqbMNRa2sDqfaxFExFaWHs5py
         Ml6tDhsyFTO1GJl8yP8nmpQiJHjaXnjv1xyE0=
MIME-Version: 1.0
Date: Wed, 14 Apr 2010 08:12:57 -0700
Message-ID: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com>
Subject: MacBookPro2,2 unable too boot with the latest HEAD
From: Justin Mattock <justinmattock@gmail.com>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed this this morning,
system can only boot up when I take the battery
out.(when the battery is plugged in this(below)
shows up, and if booting no go)

[  169.207193] divide error: 0000 [#1] SMP
[  169.207203] last sysfs file: /sys/devices/platform/applesmc.768/light
[  169.207208] CPU 0
[  169.207212] Modules linked in: rfcomm sco radeon bnep l2cap ttm
drm_kms_helper drm ipt_LOG iptable_nat nf_nat xt_state
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
iptable_filter ip_tables x_tables btusb bluetooth firewire_ohci ath9k
firewire_core ath9k_common video battery ac ath9k_hw evdev joydev
ohci1394 ath button thermal sky2 i2c_i801 raw1394 ieee1394 uhci_hcd
ehci_hcd coretemp acpi_cpufreq processor appletouch applesmc uvcvideo
[  169.207303]
[  169.207310] Pid: 182, comm: kacpi_notify Not tainted
2.6.34-rc3-00502-gd3b0936 #42 Mac-F42187C8/MacBookPro2,2
[  169.207316] RIP: 0010:[<ffffffff81237e43>]  [<ffffffff81237e43>]
acpi_ex_extract_from_field+0xb1/0x24a
[  169.207332] RSP: 0018:ffff88003eced8d0  EFLAGS: 00010246
[  169.207338] RAX: 00000000000000ff RBX: ffff88003ec61090 RCX: 0000000000000000
[  169.207343] RDX: 0000000000000000 RSI: 00000000000000ff RDI: ffff88003ec61090
[  169.207349] RBP: ffff88003eced940 R08: 0000000000000080 R09: ffffffff815fde18
[  169.207355] R10: ffffffff00000008 R11: ffffffff8165a740 R12: ffff88003ed445a0
[  169.207361] R13: 0000000000000020 R14: ffff88003a102c30 R15: ffff88003eced908
[  169.207368] FS:  0000000000000000(0000) GS:ffff880001a00000(0000)
knlGS:0000000000000000
[  169.207374] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  169.207380] CR2: 00000000009b42c0 CR3: 000000000165c000 CR4: 00000000000006f0
[  169.207386] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  169.207392] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  169.207398] Process kacpi_notify (pid: 182, threadinfo
ffff88003ecec000, task ffff88003eda0fe0)
[  169.207403] Stack:
[  169.207407]  ffff88003a102c30 0000000000000010 ffff88003ed445a0
0000000000000020
[  169.207416] <0> ffff88003a102c30 ffff88003a102c30 ffff88003eced920
ffffffff8124fd7e
[  169.207427] <0> ffffffff815d2842 ffff88003ec61090 ffff88003ed445a0
0000000000000020
[  169.207439] Call Trace:
[  169.207449]  [<ffffffff8124fd7e>] ? acpi_ut_exit+0x31/0x39
[  169.207460]  [<ffffffff81235992>] acpi_ex_read_data_from_field+0x297/0x2e9
[  169.207469]  [<ffffffff8123eaf8>] acpi_ex_resolve_node_to_value+0x320/0x444
[  169.207479]  [<ffffffff812369a8>] acpi_ex_resolve_to_value+0x374/0x404
[  169.207488]  [<ffffffff8122c183>] acpi_ds_evaluate_name_path+0x9c/0x13e
[  169.207496]  [<ffffffff8124febc>] ? acpi_ut_trace_ptr+0x66/0x68
[  169.207504]  [<ffffffff81229da3>] acpi_ds_exec_end_op+0xd9/0x646
[  169.207513]  [<ffffffff8124a5d8>] acpi_ps_parse_loop+0xc89/0xf69
[  169.207523]  [<ffffffff810e503e>] ? __slab_free+0x2bb/0x2ff
[  169.207532]  [<ffffffff81248ec5>] acpi_ps_parse_aml+0x162/0x462
[  169.207540]  [<ffffffff8124fc79>] ? acpi_ut_ptr_exit+0x36/0x3e
[  169.207548]  [<ffffffff8124b29c>] acpi_ps_execute_method+0x272/0x3ba
[  169.207556]  [<ffffffff8124fd7e>] ? acpi_ut_exit+0x31/0x39
[  169.207564]  [<ffffffff81243791>] acpi_ns_evaluate+0x235/0x3b6
[  169.207573]  [<ffffffff81242c0e>] acpi_evaluate_object+0x235/0x397
[  169.207586]  [<ffffffffa01264bf>] acpi_battery_update+0xe9/0x26d [battery]
[  169.207597]  [<ffffffff8142cd84>] ? schedule+0x67b/0x747
[  169.207607]  [<ffffffffa012666e>] acpi_battery_notify+0x2b/0x87 [battery]
[  169.207617]  [<ffffffff8121e4ee>] acpi_device_notify+0x14/0x16
[  169.207626]  [<ffffffff81231553>] acpi_ev_notify_dispatch+0x67/0x80
[  169.207634]  [<ffffffff8121afbf>] acpi_os_execute_deferred+0x24/0x31
[  169.207644]  [<ffffffff8106e67f>] worker_thread+0x1be/0x24a
[  169.207652]  [<ffffffff8121af9b>] ? acpi_os_execute_deferred+0x0/0x31
[  169.207661]  [<ffffffff81072321>] ? autoremove_wake_function+0x0/0x34
[  169.207670]  [<ffffffff8106e4c1>] ? worker_thread+0x0/0x24a
[  169.207678]  [<ffffffff81071f0b>] kthread+0x7a/0x82
[  169.207688]  [<ffffffff81027e24>] kernel_thread_helper+0x4/0x10
[  169.207696]  [<ffffffff81071e91>] ? kthread+0x0/0x82
[  169.207704]  [<ffffffff81027e20>] ? kernel_thread_helper+0x0/0x10
[  169.207708] Code: b8 0b 00 00 00 e9 ab 01 00 00 31 c0 48 8b 7d b8
31 d2 44 89 e9 4c 8d 7d c8 f3 aa 48 89 df 0f b6 4b 25 8b 73 18 8d 74
31 ff 89 f0 <f7> f1 31 d2 89 45 b4 0f b6 43 24 8d 04 06 31 f6 f7 f1 31
c9 89
[  169.207802] RIP  [<ffffffff81237e43>] acpi_ex_extract_from_field+0xb1/0x24a
[  169.207811]  RSP <ffff88003eced8d0>
[  169.207821] ---[ end trace 27efbb4e1cf07704 ]---


only patches I have on top of the current HEAD are:
http://lkml.org/lkml/2010/4/13/433
http://lkml.org/lkml/2010/4/11/86

I'm seeing applesmc.c in the mix,  but just
verified that they are not the cause.
(git reset --hard origin).

Now I just noticed there is already a bug
filed and a patch:
https://bugzilla.kernel.org/show_bug.cgi?id= 15749

I did try this patch out and yes it does fix the
boot hang, and Oops.


-- 
Justin P. Mattock
