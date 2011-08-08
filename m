Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1HHCgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 22:36:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39348 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1HHCgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 22:36:41 -0400
Date: Mon, 8 Aug 2011 12:36:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the sh tree with Linus' tree
Message-Id: <20110808123627.2c151560593ead828dd2f001@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Aug_2011_12_36_27_+1000_KzKdfvGnpRSAYmTX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Aug_2011_12_36_27_+1000_KzKdfvGnpRSAYmTX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the sh tree got a conflict in
drivers/tty/serial/sh-sci.c between commit fc97114b8d67 ("sh: Fix boot
crash related to SCI") from Linus' tree and commit ad75b88ac379 ("serial:
sh-sci: Fix up default regtype probing") from the sh tree.

These do the same thing slightly differently ("ret" v. "ret !=3D 0").  I
used the version from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Aug_2011_12_36_27_+1000_KzKdfvGnpRSAYmTX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOP0urAAoJEDMEi1NhKgbsSw0H/0uQd5Ym8I5qdH9oOjM8I8/J
grk+r/v3ioZtzRA7Pemn/NiIEP1Gr/CY6zLt/zpiGYroyVeiweR9IC3ked/pKIGE
8R4FDkgU+ZRM0YtqSYnj7YIai1R1Y8rbnDrNI9LJlWse91j0e5XgvuhiYRoNc4ci
Pg2pwiAATHwYSYcRR632V6260Z45fd0TWjGLe2ZL26pkSJB3AWP1kTNcEEVWtHqa
gU95zozS+cAyCcSwt1q70rY2swfRBsr7fbntoGnadpXGmOVnPXAQJYSH/JHwAx88
hRsF5EoyR4OAFip6We9q0IrdwiBb/U6FmEuRlSgieZ9WCsM3FroRa1x5y3aMjUU=
=faEr
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Aug_2011_12_36_27_+1000_KzKdfvGnpRSAYmTX--
