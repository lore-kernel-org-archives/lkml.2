Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab2EPXO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 19:14:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33387 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760767Ab2EPXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 19:14:26 -0400
Date: Thu, 17 May 2012 09:14:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: bad commit in the tile tree
Message-Id: <20120517091417.62c65eea7002be18d8af2f34@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_May_2012_09_14_17_+1000_du55SB5k=kvMb.iK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_May_2012_09_14_17_+1000_du55SB5k=kvMb.iK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

The top commit on the tile tree has a bad description ("usb hackery" does
not tell us anything), sprinkles stuff (mainly printk()s) all over the
generic usb code and is not signed off by anyone ...

I assume it is a debugging patch (or similar) and should *not* be in
linux-next.

I will use the version of the tile tree from next-20120516 for today
(unless you update your tree very soon).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_May_2012_09_14_17_+1000_du55SB5k=kvMb.iK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtDTJAAoJEECxmPOUX5FEUkUP/38qlyadDdLcYXxNMFqFBFCP
Hc1aFR443RTXz7peMvGF85n6RLfHpwA6gSVQM5QW5hz87Dq4HotiB7o6b7kD2mVv
TSiFsEoo86wesOlv/DevW+s0/ThUIDOSztY4efpCb06ce5hkSndABqjzTnrTC3ws
w2gB9g2MDNEz/10Gy5jQC9vseoDRlfPjeZXo4xl+rxYzt5Ts7CkdhqcZCdG6FODV
ZuDpm03KCAIp7+FvUcoHtxmGfD1rtXV6Rs/KKHmsrm9dTQ1hpFa2DLf9t6gkXcMm
LZAH6hV+U+JZ7hQcPTKpB4eKYcZLP5TYUryU00nk25q8lc/z6yVa1fnrNomnFZuu
uzPf9Dq2cEhLvt+djJ1Tu3wNREqosrlnRWcYcGuKSxYCOk0wzCcolhcuUOAzw92U
GeDsuIHvLCa1JFBDbN0YbNQBYdF6HrOKDxz7haVWi9RnMSpr9PpNvtQmmTY1bEes
DMmfO640M8nhSlsIXZfp6jjqk0Ae/ffnt7YZTCOMPqmE8+K5Gm8JL2eAiMDHuncq
TxHPWM+dZsRxRvYwa6QvqluCiUbrXkc0vgYqyi+6V6hwS5Mc7cHVad8CFfsOoGS/
HEx9cE3ZXWAejAMjuLtY0apm2JvVDb6+nbscc4sgV+Gwz4r83tnZISFUHQ6Jz68z
FbxrWpYbf63IanU6U8Wy
=HXMw
-----END PGP SIGNATURE-----

--Signature=_Thu__17_May_2012_09_14_17_+1000_du55SB5k=kvMb.iK--
