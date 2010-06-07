Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0FGGOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:14:12 -0400
Received: from eazy.amigager.de ([213.239.192.238]:60090 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0FGGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:14:11 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2010 02:14:11 EDT
Date: Mon, 7 Jun 2010 08:08:24 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: bluetooth related crash in 2.6.34
Message-ID: <20100607060824.GA2985@x61.home>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I got the attached oops when starting wvdial. I saw similar crashes
with older kernel versions, like 2.6.33 and maybe 2.6.32.

Regards,
Tino

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg2

Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
rfcomm_tty_ioctl: TIOCGSERIAL is not supported
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
rfcomm_tty_ioctl: TIOCGSERIAL is not supported
rfcomm_tty_ioctl: TIOCGSERIAL is not supported
Bridge firewalling registered
virbr0: starting userspace STP failed, starting kernel STP
virbr2: starting userspace STP failed, starting kernel STP
virbr1: starting userspace STP failed, starting kernel STP
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
rfcomm_tty_ioctl: TIOCGSERIAL is not supported
kernel tried to execute NX-protected page - exploit attempt? (uid: 1000)
BUG: unable to handle kernel paging request at ffffea0001ceaf70
IP: [<ffffea0001ceaf70>] 0xffffea0001ceaf70
PGD 1f00067 PUD 1f01067 PMD 8000000003c001e3 
Oops: 0011 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
CPU 1 
Modules linked in: tun ipt_MASQUERADE iptable_nat nf_nat bridge stp llc kvm_intel kvm ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc sco rfcomm l2cap btusb bluetooth option usbserial uhci_hcd ehci_hcd cpufreq_stats ipv6 tp_smapi thinkpad_ec loop thinkpad_acpi rfkill nvram evdev [last unloaded: cfg80211]

Pid: 8722, comm: wvdial Not tainted 2.6.34-04985-g675bc02 #13 766636G/766636G
RIP: 0010:[<ffffea0001ceaf70>]  [<ffffea0001ceaf70>] 0xffffea0001ceaf70
RSP: 0018:ffff8800ac9c1950  EFLAGS: 00010282
RAX: ffff8800acb2f400 RBX: ffff8800ac9c1fd8 RCX: 0000000000000004
RDX: ffff8800ac9c1ad8 RSI: ffff8800b366c850 RDI: ffff8800ac9c1958
RBP: 00007ffffffff000 R08: 0000000000000004 R09: ffff8800b366c850
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800afcfd2c0
R13: ffff8800b36ee728 R14: ffff8800a3307000 R15: 0000000000000000
FS:  00007f756529d720(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffea0001ceaf70 CR3: 00000000bc3ad000 CR4: 00000000000026a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process wvdial (pid: 8722, threadinfo ffff8800ac9c0000, task ffff8800be183790)
Stack:
 ffffffff81370c0b 0000000000000000 ffffffff8116f58a 0000000000000000
<0> ffffffff00000001 0000000000000000 0000000000000000 0000000000000000
<0> 0000000000000000 0000000000000000 ffff8800be183790 0000000000000000
Call Trace:
 [<ffffffff81370c0b>] ? sock_sendmsg+0xab/0xe0
 [<ffffffff8116f58a>] ? do_get_write_access+0x40a/0x600
 [<ffffffff810eecab>] ? __getblk+0x1b/0x2d0
 [<ffffffff811421d2>] ? ext4_da_get_block_prep+0x272/0x2e0
 [<ffffffff8116e57a>] ? jbd2_journal_dirty_metadata+0xba/0x1d0
 [<ffffffff81157a8b>] ? __ext4_handle_dirty_metadata+0x7b/0x100
 [<ffffffff81094a19>] ? perf_event_task_sched_out+0x49/0x360
 [<ffffffff81370c79>] ? kernel_sendmsg+0x39/0x50
 [<ffffffffa009d114>] ? rfcomm_send_frame+0x34/0x40 [rfcomm]
 [<ffffffffa009d179>] ? rfcomm_send_disc+0x59/0x60 [rfcomm]
 [<ffffffff81433310>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffffa009d824>] ? __rfcomm_dlc_close+0x264/0x2b0 [rfcomm]
 [<ffffffffa009de19>] ? rfcomm_dlc_close+0x29/0x50 [rfcomm]
 [<ffffffffa00a23f4>] ? rfcomm_tty_close+0x44/0x100 [rfcomm]
 [<ffffffff812798c2>] ? tty_release+0x172/0x6a0
 [<ffffffff814332d2>] ? _raw_spin_unlock_irqrestore+0x12/0x40
 [<ffffffff8137966e>] ? skb_dequeue+0x5e/0x80
 [<ffffffff81433310>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffffa00a326c>] ? rfcomm_tty_open+0x24c/0x330 [rfcomm]
 [<ffffffff81036b90>] ? default_wake_function+0x0/0x20
 [<ffffffff8127a6e6>] ? tty_open+0x526/0x5f0
 [<ffffffff810cb5b0>] ? chrdev_open+0x0/0x220
 [<ffffffff810cb6c7>] ? chrdev_open+0x117/0x220
 [<ffffffff8143363e>] ? _raw_spin_lock+0xe/0x30
 [<ffffffff810c656c>] ? __dentry_open+0xfc/0x330
 [<ffffffff810d399d>] ? do_last+0x35d/0x6a0
 [<ffffffff810d5caf>] ? do_filp_open+0x1ff/0x630
 [<ffffffff810c807f>] ? do_sync_write+0xbf/0x100
 [<ffffffff8143363e>] ? _raw_spin_lock+0xe/0x30
 [<ffffffff81207343>] ? _atomic_dec_and_lock+0x73/0xa0
 [<ffffffff81433310>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff810e041a>] ? alloc_fd+0xfa/0x140
 [<ffffffff810c634a>] ? do_sys_open+0x6a/0x140
 [<ffffffff81002deb>] ? system_call_fastpath+0x16/0x1b
Code: ff ff ff 18 f8 ce 85 00 88 ff ff 50 d2 11 88 00 88 ff ff 36 00 00 00 00 00 00 00 e0 d3 26 02 00 ea ff ff c0 7b ce 01 00 ea ff ff <6c> 00 10 00 00 00 00 40 02 00 00 00 ff ff ff ff 00 00 00 00 00 
RIP  [<ffffea0001ceaf70>] 0xffffea0001ceaf70
 RSP <ffff8800ac9c1950>
CR2: ffffea0001ceaf70
---[ end trace c8500afe253735c0 ]---

--a8Wt8u1KmwUX3Y2C--
