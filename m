Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1E2IDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:03:18 -0400
Received: from lo.gmane.org ([80.91.229.12]:43086 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1E2IDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:03:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Trace during boot
Date: Sun, 29 May 2011 10:02:59 +0200
Message-ID: <irsuji$6h8$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 0x4dd52733.adsl.cybercity.dk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list, I got the below trace during boot (got it from dmesg). I don't know
if it's anything serious, just thought I'd pass it on.

//Niels

------------[ cut here ]------------
WARNING: at kernel/printk.c:288 do_syslog+0x83/0x40a()
Hardware name: P5Q SE
Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG (deprecated).
Modules linked in: snd_seq_midi snd_seq_midi_event snd_seq vboxnetadp
vboxnetflt vboxdrv nvidia(P) snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_pcm snd_timer pcspkr snd_page_alloc ac97_bus
snd_i2c snd_mpu401_uart snd_rawmidi snd_seq_device snd
Pid: 2482, comm: syslog-ng Tainted: P            2.6.38-gentoo-r6 #2
Call Trace:
 [<ffffffff81030f8e>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff81031041>] ? warn_slowpath_fmt+0x45/0x4a
 [<ffffffff81031f61>] ? do_syslog+0x83/0x40a
 [<ffffffff810b37dd>] ? do_lookup+0x1c5/0x27b
 [<ffffffff810f11f0>] ? kmsg_release+0x0/0x18
 [<ffffffff810e8e48>] ? proc_reg_open+0x8d/0x121
 [<ffffffff810e8dbb>] ? proc_reg_open+0x0/0x121
 [<ffffffff810a9d00>] ? __dentry_open+0x112/0x21a
 [<ffffffff810b4932>] ? finish_open+0x97/0x14d
 [<ffffffff810b6721>] ? do_filp_open+0x161/0x573
 [<ffffffff810d4275>] ? fsnotify_clear_marks_by_inode+0x20/0xbd
 [<ffffffff810bf4bc>] ? alloc_fd+0x69/0x10a
 [<ffffffff810a9b26>] ? do_sys_open+0x56/0xe1
 [<ffffffff81001efb>] ? system_call_fastpath+0x16/0x1b
---[ end trace dc3209c35a681fed ]---

