Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1E0MzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:55:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:47891 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab1E0MzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:55:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Niels <zorglub_olsen@hotmail.com>
Subject: Problems with a docking station
Date: Fri, 27 May 2011 14:55:09 +0200
Message-ID: <iro6vf$r9f$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 0x4dd52733.adsl.cybercity.dk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi people,

I'm not quite sure were this problem belongs...

I have an AGK hard disk docking station, like this:

http://www.agknordic.com/index.php?side_id=387

It works fine, as in I can transfer files. The problem is that it apparently
disconnects disks forcefully. If i put one disk in, it gets mounted fine
as, say, sdg1. But if I then put in another disk, the first one is
disconnected, and they are both discovered by the system, as sdg1 and sdh1.

This is obviously not so good for the file systems.

One time I got this:

usb 2-2.2.5: USB disconnect, address 13
EXT3-fs error (device sdg1): ext3_find_entry: reading directory #2 offset 0
------------[ cut here ]------------
WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x23/0x7d()
Hardware name: P5Q SE
Modules linked in: coretemp snd_seq_midi snd_seq_midi_event snd_seq
vboxnetadp vboxnetflt vboxdrv snd_ice1712 snd_ice17xx_ak4xxx
snd_ak4xxx_adda snd_cs8427 snd_ac97_codec snd_pcm nvidia(P) snd_timer
snd_page_alloc ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi pcspkr
snd_seq_device snd
Pid: 12456, comm: umount Tainted: P           2.6.34-gentoo-r11 #1
Call Trace:
 [<ffffffff8102e246>] ? warn_slowpath_common+0x76/0x8c
 [<ffffffff810b9ce1>] ? mark_buffer_dirty+0x23/0x7d
 [<ffffffff810f0176>] ? ext3_put_super+0x95/0x256
 [<ffffffff8109de8b>] ? generic_shutdown_super+0x4f/0xea
 [<ffffffff8109df46>] ? kill_block_super+0x20/0x35
 [<ffffffff8109e377>] ? deactivate_super+0x43/0x5c
 [<ffffffff810b032d>] ? sys_umount+0x2b7/0x2e2
 [<ffffffff81001e6b>] ? system_call_fastpath+0x16/0x1b
---[ end trace 701147f5a82f1cb9 ]---


Yes, I know it's an old kernel. I've been having printer problems with 35
and 36. Could the above problem possibly be solved in a newer release, or
is this simply poor hardware design?


Thanks,
Niels

