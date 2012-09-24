Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2IXI1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:27:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42564 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2IXI1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:27:07 -0400
Date: Mon, 24 Sep 2012 18:26:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120924182656.c0daf6d68a9d1447ace4bf8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_18_26_56_+1000_ap7JuZPpYDAxo/ux"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_18_26_56_+1000_ap7JuZPpYDAxo/ux
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-davinci/dm365.c between commit 896f66b7de29 ("ASoC/ARM:
Davinci: McASP: split asp header into platform and audio specific") from
the  tree and commit ec2a0833e515 ("ARM: davinci: move platform_data
definitions") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/dm365.c
index f473745,719e22f..0000000
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@@ -29,8 -29,9 +29,8 @@@
  #include <mach/time.h>
  #include <mach/serial.h>
  #include <mach/common.h>
- #include <mach/keyscan.h>
- #include <mach/spi.h>
 -#include <mach/asp.h>
+ #include <linux/platform_data/keyscan-davinci.h>
+ #include <linux/platform_data/spi-davinci.h>
  #include <mach/gpio-davinci.h>
 =20
  #include "davinci.h"

--Signature=_Mon__24_Sep_2012_18_26_56_+1000_ap7JuZPpYDAxo/ux
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYBlQAAoJEECxmPOUX5FECHMP/i+pXjS8qKXFuWNiXX9wBES7
6xIwzSh8zLzvoQ8G6ZiJjQewRwYKJicks1G34TXMlpe6Yb3z5x8I7lJ6py0zt3eu
IDhPuJW5L4w5Ps3DBB98WX3+SehDBEWecQxw907Eu6X4DvlSVbHZtNiHis5Rr2+I
qWAUWTBjUinldej2/xIVYB+s2qTJ0tsYMJL73J68bYC3cNx1bn3FDAmda70Jd2Qc
w9U/50ZVdcV8TfUhYW72rn58bNcT+RpGMoO0wvDiMTz3dXMraixIy47TI6CIybeA
Az4NS53tk1gSAFehawHt3cTD09DcGecodfP3aPeR24luEB0I7hbPEd3uaF8JfTo7
yu1wgU2B45x02W4LiBx4WBNDc8gY9SefWy88T+FBU5Ffq/3pFSa3gkyEHvrKC9VY
ZML05S30Rhl93Lx2I9prqNBDtILtC77msIU/JP6E2aUBTijLNsLqVQMQJ/jFD78a
cryd5DQcCSxZsLuAcBruTlwMvVnkTb+1hrtuh2a5xDiPyOOyp9zp8iRQHM2mGH1m
8znP9EUVBpdtaZxkVwv9ha0wCqwra10G1I4cRJotxfJUYIUTTDi6Kw2K8mkoFmjS
MPGkNSv8o4DPldyasJkytYhVpvZjgOaRAO0TEYTxB5OoYfYyxZswbvgltix3k7gb
C/Rwdc3QRgvJFaaFfUgs
=H/Uf
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_18_26_56_+1000_ap7JuZPpYDAxo/ux--
