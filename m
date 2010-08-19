Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab0HSBQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:16:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60060 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0HSBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jc0X4MeszmnCQC+XdGrc6lUqBdwgylUcVJ3vECvNOzNaub0FqAxlvu6kiM//8t/Nnq
         cZArXBmsd3MOtiNYmfVbxfxig8EuIJPYlSKeVd8p5ZSvmJ2dJWlXaaBe1f9NhGxDv2zR
         eJaJw0aw1I4cA+go3JeTywKLj2F4VMuNEyrfs=
MIME-Version: 1.0
Date: Thu, 19 Aug 2010 09:16:26 +0800
Message-ID: <AANLkTi=m8GPqj2g9GXK+Kmh2dpeCba7vfyGaax3AWZjz@mail.gmail.com>
Subject: RIP: 0010:[<ffffffff81495d87>] [<ffffffff81495d87>] _raw_spin_lock_irq+0x1b/0x2b
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        Linux USB <linux-usb@vger.kernel.org>,
        Adrian Drzewiecki <adriand@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a vmware bug or kernel, so I'm posting it here.
Tried to upgrade my iPhone4 iOS to 4.0.2 running a VMware guest with
Linux-2.6.35+ and Linux-2.6.36-rc1, and both has the same problem.
"Sync" has no issue but I guess upgrading the firmware with a 600MB
file is a difference story. Could this be cable problem or a real bug?

Thanks,
Jeff.


# on 2.6.35+

2010-08-19T02:03:22.069981+08:00 boston kernel: Pid: 10376, comm:
vmware-vmx Not tainted 2.6.35+ #2 5413FGA/5413FGA
2010-08-19T02:03:22.069984+08:00 boston kernel: RIP:
0010:[<ffffffff81495d87>]  [<ffffffff81495d87>]
_raw_spin_lock_irq+0x1b/0x2b
2010-08-19T02:03:22.069986+08:00 boston kernel: RSP:
0018:ffff88010df27db0  EFLAGS: 00010002
2010-08-19T02:03:22.069988+08:00 boston kernel: RAX: 0000000000000100
RBX: 0000000000000000 RCX: ffff880001a928c0
2010-08-19T02:03:22.069990+08:00 boston kernel: RDX: ffffffff816fed18
RSI: 0000000000000001 RDI: 0000000000002888
2010-08-19T02:03:22.069992+08:00 boston kernel: RBP: 0000000000002888
R08: 0000000000000000 R09: dead000000200200
2010-08-19T02:03:22.069993+08:00 boston kernel: R10: ffff880236033830
R11: ffffffff816f5208 R12: ffff880236030800
2010-08-19T02:03:22.069996+08:00 boston kernel: R13: 0000000000000002
R14: ffff88023625c2b8 R15: ffff8802363f30e8
2010-08-19T02:03:22.069997+08:00 boston kernel: FS:
00007f08ce455710(0000) GS:ffff880001b00000(0000)
knlGS:0000000000000000
2010-08-19T02:03:22.069999+08:00 boston kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
2010-08-19T02:03:22.070001+08:00 boston kernel: CR2: 0000000000002888
CR3: 00000000b637b000 CR4: 00000000000006e0
2010-08-19T02:03:22.070003+08:00 boston kernel: DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
2010-08-19T02:03:22.070005+08:00 boston kernel: DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
2010-08-19T02:03:22.070008+08:00 boston kernel: Process vmware-vmx
(pid: 10376, threadinfo ffff88010df26000, task ffff8802399b4fa0)
2010-08-19T02:03:22.070010+08:00 boston kernel: Stack:
2010-08-19T02:03:22.070012+08:00 boston kernel: ffffffff813acdaf
ffff8802363f3000 ffff88023625c2a8 ffff8802363f3000
2010-08-19T02:03:22.070013+08:00 boston kernel: <0> ffffffff8133db68
00000000ffffff9c 0000000000005514 ffff8801e13b61f8
2010-08-19T02:03:22.070015+08:00 boston kernel: <0> 0000000000000000
ffff880233924b40 ffff8802363f3000 ffff8802363f30e8
2010-08-19T02:03:22.070017+08:00 boston kernel: Call Trace:
2010-08-19T02:03:22.070019+08:00 boston kernel: [<ffffffff813acdaf>] ?
hid_pre_reset+0x25/0x4f
2010-08-19T02:03:22.070021+08:00 boston kernel: [<ffffffff8133db68>] ?
usb_reset_device+0x6a/0x11b
2010-08-19T02:03:22.070023+08:00 boston kernel: [<ffffffff8134a040>] ?
usbdev_do_ioctl+0x2c8/0xd88
2010-08-19T02:03:22.070026+08:00 boston kernel: [<ffffffff81027f74>] ?
__wake_up_common+0x41/0x78
2010-08-19T02:03:22.070028+08:00 boston kernel: [<ffffffff8134ab18>] ?
usbdev_ioctl+0x9/0xd
2010-08-19T02:03:22.070030+08:00 boston kernel: [<ffffffff810acd7e>] ?
vfs_ioctl+0x23/0x93
2010-08-19T02:03:22.070032+08:00 boston kernel: [<ffffffff810ad265>] ?
do_vfs_ioctl+0x405/0x43c
2010-08-19T02:03:22.070034+08:00 boston kernel: [<ffffffff810ad2d8>] ?
sys_ioctl+0x3c/0x5c
2010-08-19T02:03:22.070037+08:00 boston kernel: [<ffffffff81001f42>] ?
system_call_fastpath+0x16/0x1b
2010-08-19T02:03:22.070040+08:00 boston kernel: Code: c1 07 38 e0 74
06 f3 90 8a 07 eb f6 48 89 d0 c3 fa 66 0f 1f 44 00 00 65 48 8b 04 25
48 b5 00 00 ff 80 44 e0 ff ff b8 00 01 00 00 <f0> 66 0f c1 07 38 e0 74
06 f3 90 8a 07 eb f6 c3 65 48 8b 04 25
2010-08-19T02:03:22.070043+08:00 boston kernel: RIP
[<ffffffff81495d87>] _raw_spin_lock_irq+0x1b/0x2b
2010-08-19T02:03:22.070044+08:00 boston kernel: RSP <ffff88010df27db0>
2010-08-19T02:03:22.070046+08:00 boston kernel: CR2: 0000000000002888
2010-08-19T02:03:22.070048+08:00 boston kernel: ---[ end trace
209e348e5ca9eea9 ]---


# on 2.6.36-rc1

2010-08-18T23:13:59.607810+08:00 boston kernel: Pid: 7499, comm:
vmware-vmx Tainted: G        W   2.6.36-rc1 #15
2010-08-18T23:13:59.607811+08:00 boston kernel: Call Trace:
2010-08-18T23:13:59.607814+08:00 boston kernel: [<ffffffff81499a9b>] ?
schedule+0xdf/0x68c
2010-08-18T23:13:59.607816+08:00 boston kernel: [<ffffffff8149a391>] ?
schedule_timeout+0x18c/0x1b2
2010-08-18T23:13:59.607823+08:00 boston kernel: [<ffffffff8103cd65>] ?
process_timeout+0x0/0xa
2010-08-18T23:13:59.607826+08:00 boston kernel: [<ffffffff8103d2c1>] ?
msleep+0x16/0x1d
2010-08-18T23:13:59.607829+08:00 boston kernel: [<ffffffff812744c4>] ?
ironlake_disable_fbc+0x2e/0x51
2010-08-18T23:13:59.607831+08:00 boston kernel: [<ffffffff81275dfa>] ?
intel_pipe_set_base+0x338/0x3d8
2010-08-18T23:13:59.607834+08:00 boston kernel: [<ffffffff8124cf4e>] ?
drm_crtc_helper_set_config+0x687/0x7d6
2010-08-18T23:13:59.607837+08:00 boston kernel: [<ffffffff8124b098>] ?
drm_fb_helper_pan_display+0x64/0x9a
2010-08-18T23:13:59.607840+08:00 boston kernel: [<ffffffff811e87e2>] ?
fb_pan_display+0xb4/0xee
2010-08-18T23:13:59.607844+08:00 boston kernel: [<ffffffff811f34d5>] ?
bit_update_start+0x19/0x35
2010-08-18T23:13:59.607847+08:00 boston kernel: [<ffffffff811f07c3>] ?
fbcon_switch+0x452/0x457
2010-08-18T23:13:59.607849+08:00 boston kernel: [<ffffffff8124008c>] ?
redraw_screen+0x106/0x1e4
2010-08-18T23:13:59.607852+08:00 boston kernel: [<ffffffff811f02f7>] ?
fbcon_blank+0x1a1/0x21b
2010-08-18T23:13:59.607854+08:00 boston kernel: [<ffffffff8103353b>] ?
release_console_sem+0x184/0x1b5
2010-08-18T23:13:59.607857+08:00 boston kernel: [<ffffffff814995b7>] ?
printk+0x40/0x45
2010-08-18T23:13:59.607860+08:00 boston kernel: [<ffffffff8103ca07>] ?
lock_timer_base+0x25/0x49
2010-08-18T23:13:59.607863+08:00 boston kernel: [<ffffffff8103d284>] ?
mod_timer+0x17d/0x18c
2010-08-18T23:13:59.607866+08:00 boston kernel: [<ffffffff8124024b>] ?
do_unblank_screen+0xe1/0x14e
2010-08-18T23:13:59.607868+08:00 boston kernel: [<ffffffff811c8c41>] ?
bust_spinlocks+0x15/0x34
2010-08-18T23:13:59.607871+08:00 boston kernel: [<ffffffff81005a06>] ?
oops_end+0x12/0x93
2010-08-18T23:13:59.607873+08:00 boston kernel: [<ffffffff81020073>] ?
no_context+0x1f4/0x1ff
2010-08-18T23:13:59.607876+08:00 boston kernel: [<ffffffffa0025a71>] ?
Task_Switch+0x3cc/0xcd3 [vmmon]
2010-08-18T23:13:59.607878+08:00 boston kernel: [<ffffffff8102050d>] ?
do_page_fault+0x17b/0x335
2010-08-18T23:13:59.607881+08:00 boston kernel: [<ffffffff810288fd>] ?
task_rq_lock+0x47/0x79
2010-08-18T23:13:59.607884+08:00 boston kernel: [<ffffffff81030682>] ?
try_to_wake_up+0x250/0x27f
2010-08-18T23:13:59.607889+08:00 boston kernel: [<ffffffff8147c796>] ?
klist_release+0xd2/0xe2
2010-08-18T23:13:59.607892+08:00 boston kernel: [<ffffffff8147c6c4>] ?
klist_release+0x0/0xe2
2010-08-18T23:13:59.607920+08:00 boston kernel: [<ffffffff8149c1d5>] ?
page_fault+0x25/0x30
2010-08-18T23:13:59.607923+08:00 boston kernel: [<ffffffff8149b7b7>] ?
_raw_spin_lock_irq+0x1b/0x2b
2010-08-18T23:13:59.607927+08:00 boston kernel: [<ffffffff813b189f>] ?
hid_pre_reset+0x25/0x4f
2010-08-18T23:13:59.607930+08:00 boston kernel: [<ffffffff8133ed54>] ?
usb_reset_device+0x6a/0x11b
2010-08-18T23:13:59.607932+08:00 boston kernel: [<ffffffff8134b2af>] ?
usbdev_do_ioctl+0x2c8/0xd88
2010-08-18T23:13:59.607935+08:00 boston kernel: [<ffffffff810400cd>] ?
group_send_sig_info+0x2d/0x7c
2010-08-18T23:13:59.607938+08:00 boston kernel: [<ffffffff810ce96a>] ?
eventfd_ctx_read+0x15a/0x16c
2010-08-18T23:13:59.607941+08:00 boston kernel: [<ffffffff8134bd87>] ?
usbdev_ioctl+0x9/0xd
2010-08-18T23:13:59.607944+08:00 boston kernel: [<ffffffff8100871e>] ?
read_tsc+0x5/0x16
2010-08-18T23:13:59.607950+08:00 boston kernel: [<ffffffff810aeaad>] ?
do_vfs_ioctl+0x418/0x465
2010-08-18T23:13:59.607952+08:00 boston kernel: [<ffffffff810aeb36>] ?
sys_ioctl+0x3c/0x5c
2010-08-18T23:13:59.607955+08:00 boston kernel: [<ffffffff81001f02>] ?
system_call_fastpath+0x16/0x1b
2010-08-18T23:13:59.607957+08:00 boston kernel: BUG: scheduling while
atomic: vmware-vmx/7499/0x00000002
