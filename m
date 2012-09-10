Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab2IJPSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:18:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58149 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab2IJPSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:18:31 -0400
Message-ID: <1347290306.5134.117.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 12/95] xhci: Switch PPT ports to EHCI on shutdown.
From: Ben Hutchings <ben@decadent.org.uk>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Robert Hancock <hancockrwd@gmail.com>
Date: Mon, 10 Sep 2012 16:18:26 +0100
In-Reply-To: <504DCA58.2030202@compulab.co.il>
References: <20120909224152.583178513@decadent.org.uk>
	 <504DCA58.2030202@compulab.co.il>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MsXo1aHrdqv9qljTVDuq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MsXo1aHrdqv9qljTVDuq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-09-10 at 14:09 +0300, Denis Turischev wrote:
> Hi Ben,
>=20
> As reported by Robert Hancock there is a typo in if statement below.
> Do you want I resubmit it? Or should we wait for Sarah Sharp review?
[...]
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -648,6 +648,9 @@ void xhci_shutdown(struct usb_hcd *hcd)
> >  {
> >  	struct xhci_hcd *xhci =3D hcd_to_xhci(hcd);
> > =20
> > +	if (xhci->quirks && XHCI_SPURIOUS_REBOOT)
>=20
>=20
> This looks like a typo, think it should be & not &&. With this code, it
> appears the quirk will always be triggered since XHCI_SPURIOUS_REBOOT is
> non-zero.
[...]

As the typo is not fixed in mainline, I can't fix it in 3.2.y yet.  So
I'll defer this until that happens.

Thanks for your review.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-MsXo1aHrdqv9qljTVDuq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUE4Ewue/yOyVhhEJAQramw/+PH9ziHPVMC/GFAa1b8e24m+zjBbatSrm
ZNKkrpVRpBjbOIftjP5gzOxBGt5DeaFfxM5iFBzjWKJ6R7VYfqzVuCC0gTV5+iTr
x6T0vdBvJHyDcjPfPJTALNLcROGpKlCsk/3bNUhZm9PNegMJAWW1X0U9W/H2PpF2
GGo1DDQA/1k4XIXkkNQuqb8uQaAjJJRgZrC46ZnkAMUqPGJ/9HETbaIQFD5/1j1V
CKOEbkrm9TDDj7pDm5XayxPX58aLzVlJq2Aie8CzLSzHD24ayncfhLdWsGdlL74V
vfw2Dp6dSEHa9xY1/eKX6SOLT2NpJyeCBc54+mqsXH3iA+w2xRpFIwdrW1X/jYyq
VCl7FVCAhB6U3gCfB07PDS77co1iHUnh14jSI47qtmuHS6H51Dr5QBJFGjmN44xu
HU0Mt05XNBTgxpTfXpc4jkzLGpNQp6lOByvKEl1iEVbPkIdpGgNw09kxSG0kgO+6
GMIrTMd3cNi1cz+DwfkcFkhuxMltkahcQGGM9fEWAjO/NJFZ3pG9e9b4x0ipRrhE
p624iVwIE9C1oAY+n7/H7FKbODUqR7yAiU+73ZL1DXkp29743v0N9JlvnSTD+O23
WkICcuJCMAbULaAvTfQrrNXsUvXb+40ueL1SySU8tkOTILEwuS9WU9Zzr5gtKdhC
r4NZCmHTctY=
=l6Wr
-----END PGP SIGNATURE-----

--=-MsXo1aHrdqv9qljTVDuq--
