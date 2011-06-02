Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab1FBCCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:02:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37172 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab1FBCC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:02:29 -0400
Date: Thu, 2 Jun 2011 12:02:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tmem tree
Message-Id: <20110602120223.4e7b3d81.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Jun_2011_12_02_23_+1000_6iOKLTY+R3+0yDyT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Jun_2011_12_02_23_+1000_6iOKLTY+R3+0yDyT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

After merging the tmem tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/built-in.o: In function `.enable_swap_info':
swapfile.c:(.text+0x41200): undefined reference to `.frontswap_init'

I have used the tmem (cleancache) tree from next-20110601 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Jun_2011_12_02_23_+1000_6iOKLTY+R3+0yDyT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5u8vAAoJEDMEi1NhKgbsx+wH/iSSTdNRpKQUrLYfTGXQ4BT8
/JL2EuVsFeVbuDKL74z9DuhvzAMtLeh0QS34aVcgoVMlTN4I7TG6XyfrXk/e/B3m
mzwy/VUm4V42t4HikpDgWbetBtexQK6Hqg+lQH7Jb6lUG2bQMZsIOS7V9zavDGlG
nei01uc8tSpwwQcaA4h89RMqDSaK4xwVkuWPeUZmVXrDAC5K5hyZRPnXtbENlJW3
gug77Kb14leldabdvdAryX7Ipw/eqOvS2UY5kPqesfle8h4Tugwgn48c8M6+WZZi
ohNvIoh2swioepwm3prnbTI4s8M1GxEmw1f4e7ME8R0av3uRioPMgWsq0O3lxsI=
=CgAk
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Jun_2011_12_02_23_+1000_6iOKLTY+R3+0yDyT--
