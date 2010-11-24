Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0KXEzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:55:49 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52084 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab0KXEzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:55:48 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: mmotm 2010-11-23 - WARNING: at drivers/tty/tty_io.c:1331
In-Reply-To: Your message of "Tue, 23 Nov 2010 16:13:06 PST."
             <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290574539_5261P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Nov 2010 23:55:39 -0500
Message-ID: <5747.1290574539@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4CEC9ACC.0097,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290574539_5261P
Content-Type: text/plain; charset=us-ascii

On Tue, 23 Nov 2010 16:13:06 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Seen during boot:

[   22.859616] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   23.015434] ------------[ cut here ]------------
[   23.015443] WARNING: at drivers/tty/tty_io.c:1331 tty_open+0x2a2/0x49a()
[   23.015446] Hardware name: Latitude E6500                  
[   23.015448] Modules linked in:
[   23.015453] Pid: 1207, comm: plymouthd Not tainted 2.6.37-rc3-mmotm1123 #3
[   23.015455] Call Trace:
[   23.015461]  [<ffffffff8103b189>] warn_slowpath_common+0x80/0x98
[   23.015465]  [<ffffffff8103b1b6>] warn_slowpath_null+0x15/0x17
[   23.015469]  [<ffffffff8128a3ab>] tty_open+0x2a2/0x49a
[   23.015475]  [<ffffffff810fd53f>] chrdev_open+0x11d/0x146
[   23.015479]  [<ffffffff810fd422>] ? chrdev_open+0x0/0x146
[   23.015483]  [<ffffffff810f7b4c>] __dentry_open+0x31a/0x483
[   23.015488]  [<ffffffff810f88fe>] nameidata_to_filp+0x50/0x57
[   23.015492]  [<ffffffff81105e53>] do_last+0x448/0x5b2
[   23.015497]  [<ffffffff81229229>] ? __raw_spin_lock_init+0x31/0x50
[   23.015501]  [<ffffffff81106205>] do_filp_open+0x248/0x64a
[   23.015507]  [<ffffffff810a5c4d>] ? trace_preempt_on+0x15/0x28
[   23.015511]  [<ffffffff81110cda>] ? alloc_fd+0x17c/0x18e
[   23.015516]  [<ffffffff8155adfc>] ? _raw_spin_unlock+0x30/0x69
[   23.015521]  [<ffffffff8155e3b8>] ? sub_preempt_count+0x35/0x49
[   23.015525]  [<ffffffff81110cda>] ? alloc_fd+0x17c/0x18e
[   23.015529]  [<ffffffff810f8965>] do_sys_open+0x60/0xfb
[   23.015533]  [<ffffffff8155a64b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   23.015537]  [<ffffffff810f8a1b>] sys_open+0x1b/0x1d
[   23.015542]  [<ffffffff8100277b>] system_call_fastpath+0x16/0x1b
[   23.015545] ---[ end trace 12db3a7ab6675b51 ]---


--==_Exmh_1290574539_5261P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7JrLcC3lWbTT17ARAsTtAJsH4HWUhE6KA7u5JM0gqXfXqmoKJgCfWsvo
lDJHz1TWSWTFbtAdCcgx4H0=
=BN94
-----END PGP SIGNATURE-----

--==_Exmh_1290574539_5261P--

