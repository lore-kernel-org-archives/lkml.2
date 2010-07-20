Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556Ab0GTUlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:41:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46298 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab0GTUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:41:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: akpm@linux-foundation.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: mmotm 2010-07-19-16-37 uploaded
In-Reply-To: Your message of "Mon, 19 Jul 2010 16:38:09 PDT."
             <201007200007.o6K07Xbg028863@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201007200007.o6K07Xbg028863@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1279658492_4591P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Jul 2010 16:41:32 -0400
Message-ID: <6434.1279658492@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4C4609FC.01A3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1279658492_4591P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Jul 2010 16:38:09 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-07-19-16-37 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

(Andrew - did we lose a bunch of -swedish-chef-fix-fix-fix.patch files? This is the second
thing that I reported back in May, worked in mm-rc3-0701, but dies in -rc5-0719...)

[   50.949361] BUG: unable to handle kernel NULL pointer dereference at (null)
[   50.950978] IP: [<(null)>] (null)
[   50.952045] PGD 11b7b0067 PUD 119d9c067 PMD 0
[   50.954744] Oops: 0010 [#1] PREEMPT SMP
[   50.954744] last sysfs file: /sys/devices/pci0000:00/0000:00:1b.0/device
[   50.954744] CPU 0
[   50.954744] Modules linked in: microcode(+) [last unloaded: scsi_wait_scan]
[   50.954744]
[   50.967468] Pid: 2994, comm: keymap Tainted: G        W   2.6.35-rc5-mmotm0719 #1 0X564R/Latitude E6500
[   50.967468] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
[   50.967468] RSP: 0018:ffff88011e7e5cb0  EFLAGS: 00010046
[   50.967468] RAX: 0000000000000000 RBX: ffff88011d8b5000 RCX: 0000000000000000
[   50.967468] RDX: ffff88011e7e5cc8 RSI: ffff88011e7e5cc8 RDI: ffff88011d8b5000
[   50.967468] RBP: ffff88011e7e5d28 R08: 0890000000000000 R09: 0000000000000001
[   50.967468] R10: ffff88011d8b5858 R11: ffff88011d8b5840 R12: 0000000000000000
[   50.967468] R13: 00000000000000a4 R14: ffff88011d8b5840 R15: 0000000000000296
[   50.967468] FS:  00007fea0676e720(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
[   50.967468] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.967468] CR2: 0000000000000000 CR3: 000000011f72b000 CR4: 00000000000406f0
[   50.967468] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   50.967468] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   50.967468] Process keymap (pid: 2994, threadinfo ffff88011e7e4000, task ffff88011e620100)
[   50.967468] Stack:
[   50.967468]  ffffffff813b4b54 ffff88011e7e5cc8 0000008100000246 00000081000000a4
[   50.967468] <0> 0000000000000004 0000000000000000 ffff88011e7e5cc4 00007fffe9f95f00
[   50.967468] <0> ffff88011b4a3300 ffff88011e7e5d28 0000000000000081 fffffffffffffff2
[   50.967468] Call Trace:
[   50.967468]  [<ffffffff813b4b54>] ? input_set_keycode+0xbc/0x13c
[   50.967468]  [<ffffffff813b7ee2>] evdev_do_ioctl+0x24c/0x816
[   51.016215]  [<ffffffff813b84e6>] ? evdev_ioctl_handler+0x3a/0x81
[   51.018336]  [<ffffffff813b84e6>] ? evdev_ioctl_handler+0x3a/0x81
[   51.021130]  [<ffffffff813b8510>] evdev_ioctl_handler+0x64/0x81
[   51.022519]  [<ffffffff813b854a>] evdev_ioctl+0xb/0xd
[   51.024439]  [<ffffffff810e91a0>] vfs_ioctl+0x31/0xa2
[   51.026408]  [<ffffffff810e9b1f>] do_vfs_ioctl+0x496/0x4c9
[   51.028337]  [<ffffffff810e9ba9>] sys_ioctl+0x57/0x96
[   51.030245]  [<ffffffff8100272b>] system_call_fastpath+0x16/0x1b
[   51.032123] Code:  Bad RIP value.
[   51.034015] RIP  [<(null)>] (null)
[   51.037307]  RSP <ffff88011e7e5cb0>
[   51.038270] CR2: 0000000000000000
[   51.038270] ---[ end trace 84b562a00a6053a0 ]---

And things go downhill from there...

--==_Exmh_1279658492_4591P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMRgn8cC3lWbTT17ARAoOXAKCBIG4I6JNvSOoqNqNKRzld+eAiDgCfeRoj
01V46nNRhReGvsZJMD4AfHg=
=4TRC
-----END PGP SIGNATURE-----

--==_Exmh_1279658492_4591P--

