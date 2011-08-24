Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab1HXEXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:23:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50543 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab1HXEXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:23:48 -0400
Date: Wed, 24 Aug 2011 14:23:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the rcu tree
Message-Id: <20110824142337.78715e4d6f9db2de68d87fe4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Aug_2011_14_23_37_+1000_+i=1LTolbe76VHD9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Aug_2011_14_23_37_+1000_+i=1LTolbe76VHD9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/rtmutex.c: In function '__rt_mutex_slowlock':
kernel/rtmutex.c:605:3: warning: suggest parentheses around assignment used=
 as truth value

Introduced by commit 83841f021d4b ("rcu: Permit rt_mutex_unlock() with
irqs disabled").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Aug_2011_14_23_37_+1000_+i=1LTolbe76VHD9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVHzJAAoJEDMEi1NhKgbsfS0H/REFaIarlPk/nXvYYRSFO9CJ
eJ63MNY38IHeGh4KHz4naiVcwHXqMUhqftXEs2hh2Q1y1A4pTmvQkrDgiqtWY2lU
LGH34ddXYu1Lp5sbfx67wtnr/hUiCHKlK02DQy6jheQBf8hxq2iRpH3zQvgvcKEq
7fz82irSp1RGgPZOUqMB+cGiEooMV3yvFS1qcjdmx7zCY7/d9W4GkoJO+EY8hzjY
E+hXwk+en3CU/y3pRvP48S5oBWASNvkwO7gkrM+NRRDc9HnxifO2hxuBfP7VJcgu
5Opix1w8eDqS9FMFnuLpwgMqeh0Gc5t4zzilV/xczuay0iAlieEf4v4IbMBaifA=
=T9n3
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Aug_2011_14_23_37_+1000_+i=1LTolbe76VHD9--
