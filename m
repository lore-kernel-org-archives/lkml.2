Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0CQD5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:57:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51378 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0CQD5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:57:10 -0400
Date: Wed, 17 Mar 2010 14:57:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20100317145702.e314f75b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Mar_2010_14_57_02_+1100_lVRRz1Vk6UjsTpoY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Mar_2010_14_57_02_+1100_lVRRz1Vk6UjsTpoY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/sched.c: In function 'SYSC_sched_getaffinity':
kernel/sched.c:4915: warning: comparison of distinct pointer types lacks a =
cast

Introduced by commit cd3d8031eb4311e516329aee03c79a08333141f1 ("sched:
sched_getaffinity(): Allow less than NR_CPUS length").  Just a usage of
min() with different types.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Mar_2010_14_57_02_+1100_lVRRz1Vk6UjsTpoY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkugUw4ACgkQjjKRsyhoI8yjtQCcCZ9Bgj9hwccxxLnWPDQ3sQ30
lu4AmgLIEnWOR93Tio33RzXL7tG6eGAJ
=q/+w
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Mar_2010_14_57_02_+1100_lVRRz1Vk6UjsTpoY--
