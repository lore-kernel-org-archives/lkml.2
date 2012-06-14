Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2FNLtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:49:22 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:56312 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab2FNLtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:49:20 -0400
Date: Thu, 14 Jun 2012 14:47:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/17] i2c: omap: ack IRQ in parts
Message-ID: <20120614114712.GR13602@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
 <1339669250-9183-10-git-send-email-balbi@ti.com>
 <20120614112017.GC31187@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xe2geHXJg22At20M"
Content-Disposition: inline
In-Reply-To: <20120614112017.GC31187@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xe2geHXJg22At20M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 14, 2012 at 12:20:17PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 14, 2012 at 01:20:42PM +0300, Felipe Balbi wrote:
> > According to flow diagrams on OMAP TRMs,
> > we should ACK the IRQ as they happen.
>=20
> You don't explain that you're adding a new dev_err() statement into the
> driver for a missing acknowledge.
>=20
> What if you're probing for a device - can this cause spam to the kernel
> console?  What if you have protocol mangling enabled with the "ignore
> lack of ack bit set" ?

indeed... maybe dev_vdbg() would fit better, or just don't add anything.

--=20
balbi

--xe2geHXJg22At20M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2c9AAAoJEIaOsuA1yqREsvMP/iE7gkRyWCUUbOpBdHz7G/sr
4lnz//06Dmx3HcX63y+b6SeXc82fEfJ10BvNBAfiXQTP4BXuLFBO2EPPClipCpoQ
8kZacT5YCbRVAYCApBySse/Zl4qKYQuNjq+Ee5ubZoz57sUpVCJ0umqesxgcwCA/
+nE171OCCFqZJWOEnlKZQjOJV3aVoJ8tMCngmJKmshr412Uyn6Owua/wcLWyUK4X
EjVmmjYs6g1DBXx5aoGv3gWYFMl2ATCzvRyuqr2//RdNvgkmybgG/h5yFOoko+mO
O+WtO19BFyPt/QPJGfGqEGWTfMNLcv2QvCs3kCISmVwrOHHVn2IiAjdkNC0BPFW1
Z3LuJfzlqE0G6WbXPzTWzQJc1kIsE0yzbi6Ul/FvokSiPhF+m+hwPWrVgCmlU8BT
Xm6SC0IXhOJuQWTfEN+BWBfShxPKp1UXBOLBcYM99bYGxYrV96Vd08/czksBcH6v
+44ntW6SwKplibfBG8Z769EtFfE7979UNpEsqf36eT0ChraHAUdwnYJRUr6X9812
B8LA/5zF8rfpRgk1lnm8MQInethtObuQlE2MJsuyi8OqGQpVGyxzvvJHDywI6fYY
DtaAOcLdyJSVke+fB9gfSBwydKMUXmEfiEPf+m+Wxis+HwDXyJGjGfPn1xxuFPku
asPlHZgdO7ODub1TP88Z
=pFLX
-----END PGP SIGNATURE-----

--xe2geHXJg22At20M--
