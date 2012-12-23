Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LWW4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 17:56:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55250 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2LWW4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 17:56:16 -0500
Date: Mon, 24 Dec 2012 09:56:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the driver-core.current tree with
 Linus' tree
Message-Id: <20121224095614.3d1fc65e9ade946cc6a8a2e1@canb.auug.org.au>
In-Reply-To: <20121224095200.a94a61d18925f30909964dfb@canb.auug.org.au>
References: <20121224095200.a94a61d18925f30909964dfb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Dec_2012_09_56_14_+1100_4k80Ol.1NrBiLhC/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2012_09_56_14_+1100_4k80Ol.1NrBiLhC/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 24 Dec 2012 09:52:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the driver-core.current tree got conflicts
> in 21 files in drivers/i2c between commit 0b255e927d47 ("i2c: remove
> __dev* attributes from subsystem") from Linus' tree and commit
> eeb30d064414 ("Drivers: i2c: remove __dev* attributes") from the
> driver-core.current tree.
>=20
> I fixed it up (taking a mixture of both commits) and can carry the fix as
> necessary (no action is required).

BTW, Greg, the patch in your tree to drivers/i2c/busses/i2c-au1550.c is
incorrect and would not build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Dec_2012_09_56_14_+1100_4k80Ol.1NrBiLhC/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ14wOAAoJEECxmPOUX5FEovsQAIq0BCjv+HpqfQFiJecD7Wrx
F/Rp1KQ997FKcydDVbYPx/F4WZmp+FbQrftlYyNARbK+HOgvkxAd5iPilJz1qjTn
D/peas1w3xBdG3o3EY0gpdsFRR9Rq3+0H1vh7zvFR+z366eHRMeN3OHFI2welOj9
LiWG+v/8sWoXl473ZKTWQ5TNh1Nt38GrKfvUksjj0LH6pk5g8HGPa4jsB3/UIIzw
GAeU/fUpgORfchoIoO1Lw3J2ErLPPW3X3pDbfGKwItWW652HHh+2ZPBKx8Qx+YqQ
2xbKsOaY8UQdb9cD8uuJ6bTTalGipQWlSRAyuDZDeXFOn0z1YDmdzmlMvosQvoi1
B2JcThZy9j3LwhoA+c6Em2tBYRv5mK8IuJJhU4WroCKobciLv3xvQwhwcTJylAbA
uP213hBl3icSSLFOT1tpaBXen+T8fDDDulY1YaUPQMpPvGJMjuVTJ6peA651oByM
pkwkrGkGMFZd2eS9tXhh4q9GsfFR2PH3GRe3RepKd/YiQC0svX5NL98rtoAmVcom
G/Js1nQkRfCRMSShw2CmvFERXsymJ17TYb+aG8rytLMnZdQBJij2lNuLuactdzlm
44qrgMj7fzNYPjN2rSc+vQB+Es8PnImUi9y4U7x9YhLqvWbGNT6QrtZ/dOJaUVFp
/FuUFI/C5Pc19XtmYyfC
=J7/S
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2012_09_56_14_+1100_4k80Ol.1NrBiLhC/--
