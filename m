Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2IXHc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:32:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45227 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2IXHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:32:56 -0400
Date: Mon, 24 Sep 2012 17:32:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the arm-soc tree with the sound tree
Message-Id: <20120924173253.ffdff508e51d05f667b76bde@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_17_32_53_+1000_fN/CIiWsXVzE6RPc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_17_32_53_+1000_fN/CIiWsXVzE6RPc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-davinci/dm355.c between commit 896f66b7de29 ("ASoC/ARM:
Davinci: McASP: split asp header into platform and audio specific") from
the sound tree and commit ec2a0833e515 ("ARM: davinci: move platform_data
definitions") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/dm355.c
index e47a3f0,adbde33..0000000
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@@ -26,7 -26,8 +26,7 @@@
  #include <mach/time.h>
  #include <mach/serial.h>
  #include <mach/common.h>
- #include <mach/spi.h>
 -#include <mach/asp.h>
+ #include <linux/platform_data/spi-davinci.h>
  #include <mach/gpio-davinci.h>
 =20
  #include "davinci.h"

--Signature=_Mon__24_Sep_2012_17_32_53_+1000_fN/CIiWsXVzE6RPc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYAylAAoJEECxmPOUX5FEfKcQAKkt4kklVgnTbomfbl7sGk9J
8oLu3DcToD5+yQRNX1f1dbNg64Y1tdC8pI1wzce8iwDG7PkvyisKl0jpOEYsDMPw
TNl9WSF/KggNBDT0dqSKLb83GtwnNDfgw8htLwWEnhUy6r97hMTcksniSZlTSaZl
HHDMp3HisDiewRe81a4xISg4CVKQPqFMgsHJIJCX3pn0zympXn39QfkJtGwLx3Wy
Y95L3hmdFajvSqrHzqzj6b5gIL2gWqvF/k0aQGU65YyHqGKG023yGDGcd5D4uVwS
/V/ylmar79sWbBENwpXtVf/mU5MiACjmf/lnFvKV5KOjVY9IRVnMZ2HL5LcYltB+
gol15MFlP+sLMPWexnvXQk8uLaYqgpIhixt4qVvi2gQW5qledMTaySZdAfo0qSa5
GhMpIfekvnH+LZoFmF9uYVie4bEbIB+CrYlQWmvoc7c/vUJxinP4w5pzWZAa7LNB
vm22MI87dpaKzPPXzd7q8fWal7k4r82ubLtwZvTivZ8EkWst2pGcYT517ctRlaVW
HYKKMwXv6CI+jZTRyU/qerZ2n2/OITc1G0uGEn7bSZyjWKhd2g5m5Zkm46kZUpj6
t/acRajHZT6V51rweveBJl5Lsuidw3jUSyDNhOQqr0gbGJNj+SD4ahwRtjwNovdE
ps9QF0jrmo8BYXOl+uuk
=bhtN
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_17_32_53_+1000_fN/CIiWsXVzE6RPc--
