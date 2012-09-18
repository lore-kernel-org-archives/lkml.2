Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2IRNsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:48:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52921 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2IRNsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:48:20 -0400
Date: Tue, 18 Sep 2012 15:48:10 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120918134810.GA16840@avionic-0098.mockup.avionic-design.de>
References: <1347958630-19672-1-git-send-email-thierry.reding@avionic-design.de>
 <50587903.9060507@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <50587903.9060507@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:8P9QDoH0YOE7C0H6OLqamciRWCfD2klgusAta3VYeg4
 p5PIgsSikWji7BUx3QRv7kN2ws9eT61mv5UZ1HU5LM55HylaC4
 iwmGGls2mS9bxPTyReiuZrzL7E2Met4fAflnjC4Z+Rp8Xf7MyP
 p59a8SFLv5uVskWEsS3HmGGzOJwPdbewC7yilCGxI0+F0CtqlA
 iZBXrkiIsDz8iY8x7yguh14CZaHeVEkKjBNVfl/gUVxNGY5ZK9
 zYGcbdWIP51b6/YYEnQn1DbOTsINce4VG9rLOtYG3qPu+Equo1
 8az97XTUyzbsza5wOQ1slV+qTMwMbSKU9/xwTuJPeLO51vVKQZ
 NO2k4KL//EV95mkA+zC5hR2psmR52SE3V/soYP9W5zdq+3NpgZ
 yNZw9LQRjYpUwcK8Xf7qguapSWYU2DxFxekdqhgaJ4km/cZIme
 2TmoW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 08:37:07AM -0500, Rob Herring wrote:
> On 09/18/2012 03:57 AM, Thierry Reding wrote:
[...]
> > diff --git a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt b/Doc=
umentation/devicetree/bindings/gpio/gpio-adnp.txt
> > new file mode 100644
> > index 0000000..5a09a21
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
> > @@ -0,0 +1,30 @@
> > +Avionic Design N-bit GPIO expander bindings
> > +
> > +Required properties:
> > +- compatible: should be "ad,gpio-adnp"
> > +- reg: The I2C slave address for this device.
> > +- interrupt-parent: phandle of the parent interrupt controller.
> > +- interrupts: Interrupt specifier for the controllers interrupt.
> > +- #gpio-cells: Should be 2. The first cell is the GPIO number and the
> > +  second cell is used to specify optional parameters:
> > +  - bit 0: polarity (0: normal, 1: inverted)
>=20
> This contradicts the documentation changes you just submitted. That's
> fine, but perhaps that documentation should say recommended encoding of
> cells unless defined differently for an individual binding.

The documentation changes were for #interrupt-cells, this is
#gpio-cells.

Thierry

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWHuaAAoJEN0jrNd/PrOhISYQAKgAx8YWuk9HTbH8npCTLmRv
BHAa/7ajWbZRnk/0GPs2JwCq8xc4YdQITlbvH8YbVMMIN8Em122McBJf1XiJi/LD
/hNws6B9ZqEbHr+mwendEQGVFpw1fITO/yPLGKwPlC9vpHZDKuN3cBMK9OCsiS54
Fa1h1kwcXHIbsdyMnsXRsmECz8W4d8k7BeIbSOaOz7awdfNXnzGMm4M8Uxc+uoiV
rpB/zeRLoOW0x5Ucx4nqctZe/2jGdHzOSSqj5NpgIQP3aePT4jp3e5nCP4dbtl+I
H/NQ7IVDVeviEnprPMWWVU1xL2Dac2OuTAFv5iHhIVl9ps45Pb/Zx6ustzyHPUWI
wouOAuW7Zjh1u9moBUSNCmE7IpdBcxiIshrOimQ0NXBYi6aphMaUUiLcbfnE2QHD
SlYxptFru2PITxb0c/X1MW3qxli1EfffAuvQYY4NbHL+HWcNsmgAK1WJgkgWLwH5
MLUh5SyoWFxfbodmI4T1VMdQ5VS5auL/MXi7qRIw3M1TfBSHyTM8uy+zEJqiF+Ey
APG/pnvEHNk4hIpMVeRtQjP/D7taaOSQzkbgTiInX8g5LctMotbuVYlm620rbuXG
mk4v7lUslidH2GMIn28CTtmzhtNIW88GDcQTZWVVn2H7fk5pMkfPnJWM+BnpsvG5
1Ve895G+TmXSq2HRTPIM
=vbuC
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
