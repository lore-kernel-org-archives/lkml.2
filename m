Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2JWK7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:59:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52268 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2JWK7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:59:21 -0400
Date: Tue, 23 Oct 2012 13:53:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20121023105339.GD24820@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
 <20121022100240.GK14033@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CE1E@BGMAIL02.nvidia.com>
 <20121022101623.GM14033@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DE0B97217@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mSxgbZZZvrAyzONB"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DE0B97217@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mSxgbZZZvrAyzONB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 23, 2012 at 04:23:19PM +0530, Venu Byravarasu wrote:
> > -----Original Message-----
> > From: Venu Byravarasu
> > Sent: Monday, October 22, 2012 4:04 PM
> > To: 'balbi@ti.com'
> > Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org; linux-
> > usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driv=
er
> >=20
> > >
> > > what is this SOC dependent PHY driver ?
> >=20
> > SOC dependent PHY driver actually deals with the PHY interface
> > programming.
> > e.g. please see code present in tegra2_usb_driver.c.
> >=20
> > > What sort of dependencies are
> > > there ? Those differences should be handled with runtime checks.
> >=20
> > As PHY related bugs got fixed across different set of SOCs apart from
> > adding few features, wanted to separate this out from common PHY
> > functionality. This will help us in adding support for different SOCs w=
ith
> > minimum set of changes.
>=20
> Felipe,
>=20
> Please let me know if you have any more questions on this patch.
> If not, can you please merge this?

Like I said before, those differences should be handled by runtime
checks, you shouldn't need separate files for that. What you need to do
is implement a single PHY driver which can handle all tegras known to
date, later you can add support for new tegras by patching a few things
here and there.

--=20
balbi

--mSxgbZZZvrAyzONB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhnczAAoJEIaOsuA1yqREfgYP/0Es45XWgAbMBnaKOeUurcLX
76R8IKFTZERDjt7aPCbwsaaZNw/0ng6hf9DwecuivYJF5s1R1B2Ss7IE1nToB3Pk
meKFfFgX+svnTGt8kkAr3DTjQLAm8HA5Jb5H6YA2fAkO1HogpcUxreFA2PRg6TgB
pv2rCIy893zviOx0IeiWj6LIZq8YNSzBRue9sgX2Hq5tLpmtYVTPrdU8PVqoXk5f
hxp30GXJvMqUUlsZPb6vNvZZMDBBoz8ZC15/UvioZ7bi7kdksKp7NaHseLbTcce+
NsrzpRqqQ+EBfwxhlRGns6LY04L+UPxiJO382Jv9cb2TjKNpGquXXLyac+hRhait
CLh6xgvzAznWd/w1ScCiH9ysTUcNkoVaevfj1cQeYo+LGgJOQIUOXUbD13sgZGf+
6DlKms9gH7Lh0Ufb2pEaJjqFPRQogvGmn77KvCwqqqZ03dhdwj3K2DL9Om66iz75
8r5KlNU38AKtiXPq7YPMDhn1Zi9hE4LtZpvJLXy1t0Ac4oCpqU+SY7uXrIQ/uFzI
ab9xeTqBKYERj8l8d9KOZy7mG43HFyiCN1mY8VeMx/xFUtYpgt0cM8z5augFpFv3
3E6tijoG5K+D5tbCYo3QwTU63Y5RuqkWON0IFDN9u+Fxo+8liqbkHq2hcnc6P5kZ
zbPCzYR0QgBRqZMK1J24
=NLi7
-----END PGP SIGNATURE-----

--mSxgbZZZvrAyzONB--
