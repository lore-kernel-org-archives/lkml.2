Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab1IAQel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:34:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51460 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab1IAQej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:34:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next RCU complaint during boot
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314894817_7603P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Sep 2011 12:33:37 -0400
Message-ID: <8867.1314894817@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E5FB3E2.01D4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314894817_7603P
Content-Type: text/plain; charset=us-ascii

Seen during boot of linux-next 20110831:

[    8.823047] ------------[ cut here ]------------
[    8.823177] WARNING: at kernel/rcutree.c:1821 rcu_needs_cpu_quick_check+0x6e/0x204()
[    8.823314] Hardware name: Latitude E6500
[    8.823418] Modules linked in:
[    8.823601] Pid: 0, comm: swapper Not tainted 3.1.0-rc4-next-20110831-dirty #11
[    8.823724] Call Trace:
[    8.823824]  <IRQ>  [<ffffffff81039682>] warn_slowpath_common+0x7e/0x96
[    8.824015]  [<ffffffff81092467>] ? note_new_gpnum+0x32/0x96
[    8.824034]  [<ffffffff810396af>] warn_slowpath_null+0x15/0x17
[    8.824034]  [<ffffffff810917de>] rcu_needs_cpu_quick_check+0x6e/0x204
[    8.824034]  [<ffffffff81093df8>] rcu_needs_cpu+0x9/0xd
[    8.824034]  [<ffffffff81065933>] tick_nohz_stop_sched_tick+0x20a/0x420
[    8.824034]  [<ffffffff8103fd77>] irq_exit+0xd2/0xe0
[    8.824034]  [<ffffffff81018f91>] smp_apic_timer_interrupt+0x8b/0x99
[    8.824034]  [<ffffffff815a1b30>] apic_timer_interrupt+0x70/0x80
[    8.824034]  <EOI>  [<ffffffff8159dbbf>] ? notifier_call_chain+0x20/0x81
[    8.824034]  [<ffffffff8159dc7e>] __atomic_notifier_call_chain+0x5e/0x90
[    8.824034]  [<ffffffff8159dc20>] ? notifier_call_chain+0x81/0x81
[    8.824034]  [<ffffffff8159dcbf>] atomic_notifier_call_chain+0xf/0x11
[    8.824034]  [<ffffffff8100092d>] cpu_idle+0xaf/0x102
[    8.824034]  [<ffffffff81569ddc>] rest_init+0xd0/0xd7
[    8.824034]  [<ffffffff81569d0c>] ? csum_partial_copy_generic+0x16c/0x16c
[    8.824034]  [<ffffffff81b31b09>] start_kernel+0x375/0x380
[    8.824034]  [<ffffffff81b3129f>] x86_64_start_reservations+0xaf/0xb3
[    8.824034]  [<ffffffff81b31393>] x86_64_start_kernel+0xf0/0xf7
[    8.824034] ---[ end trace f6289633ba846f8f ]---

Any ideas?

--==_Exmh_1314894817_7603P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOX7PhcC3lWbTT17ARAt0RAKDNFTIvipoiLiKpo8fXLyDizP1xJgCfeCjt
L/uunp5SWMuBjph6iYbROV8=
=bUjD
-----END PGP SIGNATURE-----

--==_Exmh_1314894817_7603P--

