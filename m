Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab2B2FQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 00:16:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48830 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2B2FQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 00:16:41 -0500
Date: Wed, 29 Feb 2012 16:16:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120229161627.b8dd92287d066cd7c0a0284e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_16_16_27_+1100_ekT5a9DE0=NCutiU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_16_16_27_+1100_ekT5a9DE0=NCutiU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/Kconfig between commit 6905a65879b5 ("ARM: Make the sched_clock
framework mandatory") from the arm tree and commit 4a8f83409da6 ("ARM:
sa1100: clean up clock support") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 5130989,9f134c4..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -753,7 -760,8 +753,7 @@@ config ARCH_SA110
  	select ARCH_HAS_CPUFREQ
  	select CPU_FREQ
  	select GENERIC_CLOCKEVENTS
- 	select HAVE_CLK
+ 	select CLKDEV_LOOKUP
 -	select HAVE_SCHED_CLOCK
  	select TICK_ONESHOT
  	select ARCH_REQUIRE_GPIOLIB
  	select HAVE_IDE

--Signature=_Wed__29_Feb_2012_16_16_27_+1100_ekT5a9DE0=NCutiU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTbSrAAoJEECxmPOUX5FEniMP/025VYYl6+0YIq/jHVkg+MsH
uoizLxi/p50hbgPeJcCAMqVV+s3XCgDdprk3KUmRfX38UIAm008lwIwBhhD1vm0m
7gojfa2b+j2erUwO4P7q83vK3nxhI4A3lI3oY/iKnD2kvAp0hJySBEgd+d5d8/3z
V4NsDi2zjt0yzYW+MibpiOomYLZbTcK5ZiwKYwV4ya0vllbRSxjGKQC4GVxbA1c/
1dXJ0LCPmQqLpECajAmLDxM+th03Zy80uFzFfOiyGq2L728hwRhrQc0m5I05VTbP
Io3/+BF9RBEb1/Mnj+cj7TsQ9aqehKjLBFjOUookDpWFXHb9ICmoHA/OTV2nv7MB
G7k+XgeCPE0A+jigOgVsk9U5yGcAdaZ1wgDPke16PgJlv5oMByxqOq+FSw8Cu6mn
e8wyiAo5E/b1BnkQlXzFNlOsptpOXMSXp0r7GFW1aoYW0PHJmVD48htlLnKZPN3w
/7oXUDqNn+48MNabYHgIBneAxpwR1P12pSFCgolxiQ/nNV/pETNCu4RUNQGLrgO7
dptJcLnUUw056c5ix+IK9S8ErFZ6FwKptWK5U13a3zWcnIeiiz8gDKsliOnC7hx+
SH1y1Q3x1m6h9X3ig8/gyfsMEW3fk8pB30QAk7yhEh6aHkSuk8JvDvdwzCFdaEjR
3u6mleTdEyvc4NeBwC0q
=od4M
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_16_16_27_+1100_ekT5a9DE0=NCutiU--
