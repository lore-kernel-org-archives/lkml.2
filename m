Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0KJIHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:07:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0KJIHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:07:19 -0500
Message-ID: <4CDA5291.4010802@cn.fujitsu.com>
Date: Wed, 10 Nov 2010 16:06:41 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org
Subject: WARNING in tty_io.c 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 16:07:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 16:07:44,
	Serialize complete at 2010-11-10 16:07:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify start-ttys.conf to add ttyS0 device on my Fedora13 with 2.6.37-rc1+ kernel.
After rebooting system, got the following WARNING.


------------[ cut here ]------------
WARNING: at drivers/char/tty_io.c:1331 tty_open+0x20e/0x3b2()
Hardware name: Aspire SA80
Modules linked in: ipv6 uinput snd_intel8x0 snd_ac97_codec ac97_bus r8169 ppdev parport_pc snd_seq snd_seq_device snd_pcm sis900 mii snd_timer snd soundcore parport snd_page_alloc pcspkr ata_generic pata_acpi sata_sis pata_sis [last unloaded: scsi_wait_scan]
Pid: 117, comm: plymouthd Not tainted 2.6.37-rc1+ #4
Call Trace:
 [<c044045c>] warn_slowpath_common+0x6a/0x7f
 [<c062aff0>] ? tty_open+0x20e/0x3b2
 [<c0440485>] warn_slowpath_null+0x14/0x18
 [<c062aff0>] tty_open+0x20e/0x3b2
 [<c04dc6c7>] chrdev_open+0xf3/0x110
 [<c04d8688>] __dentry_open+0x141/0x237
 [<c04d8833>] nameidata_to_filp+0x43/0x51
 [<c04dc5d4>] ? chrdev_open+0x0/0x110
 [<c04e25b8>] do_last+0x372/0x47f
 [<c04e3b8d>] do_filp_open+0x19c/0x406
 [<c04e5085>] ? do_vfs_ioctl+0x55e/0x5b4
 [<c05b6232>] ? might_fault+0x1e/0x20
 [<c04d8457>] do_sys_open+0x4d/0xcf
 [<c0581f47>] ? selinux_file_ioctl+0x43/0x46
 [<c04d8525>] sys_open+0x23/0x2b
 [<c04097df>] sysenter_do_call+0x12/0x28
 [<c07a0000>] ? init_intel_cacheinfo+0x6d/0x39e
---[ end trace eeb22dd7bedfb0b1 ]---
 
