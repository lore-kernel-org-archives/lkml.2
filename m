Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2ENMxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:53:45 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:59306 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830Ab2ENMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:53:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkIAA4AsU9bdWOb/2dsb2JhbABEhXmlSiKIDoEHghUBAQUjBFIQCxgqAgJXBoglp2aSWYsahHCBGASmPYJr
X-IronPort-AV: E=Sophos;i="4.75,586,1330902000"; 
   d="asc'?scan'208";a="907431132"
Message-ID: <1337000016.3438.5.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 1/5] Staging ipack: fix a few sparse warnings
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 14:53:36 +0200
In-Reply-To: <20120514122628.GH16984@mwanda>
References: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
	 <1336992089-2733-2-git-send-email-siglesias@igalia.com>
	 <20120514122628.GH16984@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hFT4ldoF/s+JDrAzdKK6"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hFT4ldoF/s+JDrAzdKK6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-14 at 15:26 +0300, Dan Carpenter wrote:
> On Mon, May 14, 2012 at 12:41:25PM +0200, Samuel Iglesias Gonsalvez wrote=
:
> >  	/* Read status register */
> > -	status_reg =3D readw((unsigned short *) (tpci200->info->interface_reg=
s +
> > +	status_reg =3D readw((void __iomem *) (tpci200->info->interface_regs =
+
> >  					       TPCI200_STATUS_REG));
> > =20
>=20
> Later in the patch, you do the right thing which is to declare this
> as an __iomem pointer in the header.  The cast here can be removed
> and it all fits on one line.
>=20
> Remove it in a follow on patch if you want.  Same for several of the
> other casts in this patch.

Thanks a lot. I will do it.

Regards,

Sam



--=-hFT4ldoF/s+JDrAzdKK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+xAFAACgkQWrfbyfmd9eLnxgCfaXBsWfSqcdGs0S5iVrYWdJOg
/UMAoIhvICSS1U935i/axo3jSUZrmsQP
=Oi1j
-----END PGP SIGNATURE-----

--=-hFT4ldoF/s+JDrAzdKK6--

