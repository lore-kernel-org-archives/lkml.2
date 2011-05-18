Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab1ERKu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:50:27 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53909 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab1ERKu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:50:26 -0400
Date: Wed, 18 May 2011 13:50:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com
Subject: Re: [RESEND][PATCH 1/5] arm: omap: usb: ehci and ohci hwmod
 structures for omap3 and omap4
Message-ID: <20110518105014.GD13908@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305538570-21006-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Content-Disposition: inline
In-Reply-To: <1305538570-21006-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2011 at 03:06:10PM +0530, Keshava Munegowda wrote:
> Following 2 hwmod strcuture are added:
> UHH hwmod of usbhs with uhh base address and
> EHCI , OHCI irq and base addresses.
> TLL hwmod of usbhs with the TLL base address and irq.
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

applied, thanks

--=20
balbi

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN06RmAAoJEAv8Txj19kN13UsIAJ7qTih96UZ4Sf0VFX4RRLlr
gWrP7HctnRNsDJqAlyOPAFBZlZe6NtomLtWa29mqwI0QZb0/rRog9X+dF4rv0THl
xrV9esSuNXyDqlqz5yMHTZwk/XiLlqZg4BrQXUHJAO14gZT4oFgZfTE9g21NBbP0
CwPhRUkAK3+UMpHYV792CCYdaIK/pjZPBMQfNRHtfj/yOvdqXxDVB3NXds5wY4dq
Bgt51iw9RsxSNMSjW0p7wEQTNN6CCrVeev7iYOgI+mryRcPE2sGDG+3kbMouQgC+
mGyDhbNlIcb0MZ8rIh4U04EqwG5Mpu8u+Uoht30IhbNnWfcoCzsrFa8ThJ4OtQU=
=GSuB
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--
