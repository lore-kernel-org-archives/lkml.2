Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab0EMPH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:07:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42071 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777Ab0EMPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:07:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded
In-Reply-To: Your message of "Tue, 11 May 2010 18:21:22 PDT."
             <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273763194_3844P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 13 May 2010 11:06:34 -0400
Message-ID: <6195.1273763194@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4BEC157A.01CE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273763194_3844P
Content-Type: text/plain; charset=us-ascii

On Tue, 11 May 2010 18:21:22 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Dell Latitude E6500, x86_64 kernel.

Boots to single user prompt, but has issues on the way there.  Possibly
very important - I was definitely *not* typing at the time (as I had hit
return on the LUKS passphrase for the disk at 36 seconds after boot, and
I didn't get the # prompt for single-user for another minute or two (probably
due to udev having issues due to the oops). So I have no idea what it was
trying to get a keycode for...

[   40.717136] udev: starting version 154
[   41.710153] BUG: unable to handle kernel NULL pointer dereference at (null)
[   41.711007] IP: [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
[   41.711007] PGD 11d318067 PUD 118af1067 PMD 0
[   41.711007] Oops: 0002 [#1] PREEMPT SMP
[   41.711007] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/idVendor
[   41.711007] CPU 0
[   41.711007] Modules linked in:
[   41.711007]
[   41.711007] Pid: 2501, comm: keymap Not tainted 2.6.34-rc7-mmotm0511 #2 0X564R/Latitude E6500

[   41.711007] RIP: 0010:[<ffffffff813bb996>]  [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
[   41.711007] RSP: 0018:ffff88011d513cc8  EFLAGS: 00010046
[   41.711007] RAX: 0000000000000081 RBX: ffff88011c004000 RCX: 0000000000000081
[   41.711007] RDX: 0000000000000000 RSI: ffff88011d513ce8 RDI: ffff88011c004000
[   41.711007] RBP: ffff88011d513cc8 R08: 0000000000000002 R09: 0000000000000001
[   41.711007] R10: 0000000000000069 R11: 0000000000000002 R12: ffff88011d513ce8
[   41.711007] R13: ffff88011c004830 R14: 0000000000000282 R15: ffff88011c0c1800
[   41.711007] FS:  00007f7da81f1700(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
[   41.711007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.711007] CR2: 0000000000000000 CR3: 0000000119d96000 CR4: 00000000000406f0
[   41.711007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   41.711007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   41.711007] Process keymap (pid: 2501, threadinfo ffff88011d512000, task ffff88011cea2240)
[   41.711007] Stack:
[   41.711007]  ffff88011d513d28 ffffffff813bdb62 ffff88011d513fd8 ffff88011d513dd4
[   41.711007] <0> 0000008100000000 0000000000000004 0000000000000000 0000000000000000
[   41.711007] <0> 0000000080084504 00007fffb1390a20 ffff88011c004000 ffff88011b9305c0
[   41.711007] Call Trace:
[   41.711007]  [<ffffffff813bdb62>] input_get_keycode+0x5e/0x85
[   41.711007]  [<ffffffff813c094b>] evdev_do_ioctl+0x1cd/0x79b
[   41.711007]  [<ffffffff813c0f56>] ? evdev_ioctl_handler+0x3d/0x80
[   41.711007]  [<ffffffff813c0f56>] ? evdev_ioctl_handler+0x3d/0x80
[   41.711007]  [<ffffffff813c0f7c>] evdev_ioctl_handler+0x63/0x80
[   41.711007]  [<ffffffff813c0fb6>] evdev_ioctl+0xb/0xd
[   41.711007]  [<ffffffff810e97f9>] vfs_ioctl+0x2d/0xa1
[   41.711007]  [<ffffffff810e9d9c>] do_vfs_ioctl+0x4b8/0x4fe
[   41.711007]  [<ffffffff810e9e39>] sys_ioctl+0x57/0x95
[   41.711007]  [<ffffffff810025eb>] system_call_fastpath+0x16/0x1b
[   41.711007] Code: c8 48 8b 97 d0 00 00 00 75 18 eb 10 48 63 d0 48 8b 8f d0 00 00 00 0f b6 14 11 eb 09 0f b7 14 4a eb 03 8b 14 8a 89 16 48 8b 56 18 <89> 02 31 c0 eb 05 b8 ea ff ff ff c9 c3 55 8b 56 08 4889 e5 83
[   41.711007] RIP  [<ffffffff813bb996>] input_default_getkeycode_from_index+0x4e/0x5b
[   41.711007]  RSP <ffff88011d513cc8>
[   41.711007] CR2: 0000000000000000
[   41.711007] ---[ end trace 51c151638ede785c ]---
[   41.711007] note: keymap[2501] exited with preempt_count 1



--==_Exmh_1273763194_3844P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL7BV6cC3lWbTT17ARAlMfAKC81n73DbnMSlabHLmp5tbjm/ygoACfWfTl
R/wt1mKurymrfrH137gdWQ8=
=drl8
-----END PGP SIGNATURE-----

--==_Exmh_1273763194_3844P--

