Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab2BJTp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:45:58 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:57369 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759958Ab2BJTp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:45:56 -0500
Date: Fri, 10 Feb 2012 11:45:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charlie Suffin <charlie.suffin@stratus.com>, stable@kernel.org
Subject: Re: [PATCH] pci: Add quirk for still enabled interrupts on Intel
 Sandy Bridge GPUs
Message-ID: <20120210114552.5ff66007@jbarnes-desktop>
In-Reply-To: <4EDFD5BB.1050906@intra2net.com>
References: <4EDFD5BB.1050906@intra2net.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CmlYTlKKLRX8kRasUrXYd9F"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CmlYTlKKLRX8kRasUrXYd9F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011 22:08:11 +0100
Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:

> Some BIOS implementations leave the Intel GPU interrupts enabled,
> even though no one is handling them (f.e. i915 driver is never loaded).
> Additionally the interrupt destination is not set up properly
> and the interrupt ends up -somewhere-.
>=20
> These spurious interrupts are "sticky" and the kernel disables
> the (shared) interrupt line after 100.000+ generated interrupts.
>=20
> Fix it by disabling the still enabled interrupts.
> This resolves crashes often seen on monitor unplug.

Applied to my -next branch finally (sorry I missed your last reply),
thanks Thomas.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/CmlYTlKKLRX8kRasUrXYd9F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPNXPwAAoJEIEoDkX4Qk9hie8QAJR1bepheYAePbieLOAKuUDM
5aUny3br9STY+eUcsdw4Wqqt/Cjp8qV8flFffN/8Wv1mDQxb32EYUCI/OE8s+Wzd
jIBcUwHA+N6TVBLM/BW3XcGL3kIWoEYlz636BYqqipQlNFQ/XQzyxSeceqKlwurU
DQO/NlNADrM8vedz7hmwLR+9lm9vI0rRX6cudSmqi5PECwBSBEeNLhq0LKHjWboX
iuXCVfog8qd6dLh2feRA6t+zEwM8xm9pFOQjr/3ja4r0o5yBPadccQFt+buBGkqQ
86QGo5HJDBBuwjT1/rkc9/CDDh7Xga2p+M9yDf5ukh/5/atNp2AeYATI3QgPif4A
okeaXkasZ2TLXkmb1gpcGs7KLcvf9mfmyZYBnB4H2E5ydlfdY/bF3i4vuXZBL4ST
hwcyWnqVE0rgfkBpnsx7n97qT2qHuvyV7jCVXTZH86XFjrDTtyD2lyoWt2T52AmN
0agWRw/2XTqKsQ6CsYeCzWYW2sPjMnSLLCr5KrV1vaHqLLn1qZDi234Wi8u1oK6e
6L40sCXc5pzHS2stY1k9o3v30LgH1bR5EkePxj8FMMC4ZBVcqk0yMVOIahqLGjGe
YvddFj4gs3dLzJm7utHSzuzDMzPoot8J6gqkBu/DwkmE9USKYE/Rf/BuyBuLDObi
CUMgx7M6pExWB+n/WbVM
=evjv
-----END PGP SIGNATURE-----

--Sig_/CmlYTlKKLRX8kRasUrXYd9F--
