Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2CEDXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:23:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45313 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2CEDXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:23:00 -0500
Date: Mon, 5 Mar 2012 14:22:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the pcmcia tree with the arm tree
Message-Id: <20120305142248.56e1a4719f16c246c3095cf3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Mar_2012_14_22_48_+1100_GD7vNyT47qlsyT5b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Mar_2012_14_22_48_+1100_GD7vNyT47qlsyT5b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

Today's linux-next merge of the pcmcia tree got a conflict in
drivers/pcmcia/soc_common.c between commit a7670151a48c ("PCMCIA:
soc_common: remove soc_pcmcia_*_irqs functions") from the arm tree and
commit d571c79e86fa ("pcmcia: irq: Remove IRQF_DISABLED") from the pcmcia
tree.

The former removed the code modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_Mar_2012_14_22_48_+1100_GD7vNyT47qlsyT5b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVDGIAAoJEECxmPOUX5FEhkIP/Rkf4FsL1BkWIxLDEGoe2k5h
Wgzozvg7cEsvsADdmiIYG9qFdg+y6D7aJQgLkB+nV+C0XsEHdJa7kHeeQPCmZE2t
pZMNoK7MqmI2+58CREiopv7p+PzK+BTnEed6+s8nIROAzDQnjZ8UlsDsJEgImlDs
ZzxAWpU8OSo6su72I33ytoFCNZRoLfL/P3JD1DKSOWiGTRycy5m8IBYhgZBuBMxV
r+VelISKicWsT1Kn3VMMVvpEgc2SmSOeIAXea7eIBT+Hz3TezD0c5SMTWHpmJ2S8
waoSW2A8o+HZ9or17EcE2zbcFy/nvV4EZEkW/bYdw2WlQwfG9hYcRkkH64gJvG1A
2cVGtWrBueYz324aaxfNR1mG+kc3DX2BaLYJRcQGGozEOKjVh5+hyxIzdSGo+qzn
uXSIidKvP3Xhge0ttQM/8brRje66e/BgKcANj14uztKjQzKbb66z2p4dzsUia91K
X+r0MkgikJF/h8PT6VXgls3nmqdcHpcywwwwVjrQFjNGM+KWEWSdYBr4diSc+TkD
DFsOSOfgI9dZWXKgbOSXdKDUxfx9x611ZZ1+mw0zRH6UIUTdul6VBcoR5xSXR1ii
Y+4sCqdN/TkbGw57K9iy5JzqSGiq6QPaPX0Vcr5pvgC8HhihcSdisvM1TTCqP6n+
WyMXNy6O+YIXGlbfFrlN
=HBly
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Mar_2012_14_22_48_+1100_GD7vNyT47qlsyT5b--
