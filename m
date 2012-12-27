Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2L0ShY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:37:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45321 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2L0ShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:37:20 -0500
Message-ID: <1356633430.17740.12.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 162/241] Bluetooth: ath3k: Add support for VAIO VPCEH
 [0489:e027]
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Marcos Chaparro <marcos@mrkindustries.com.ar>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date: Thu, 27 Dec 2012 19:37:10 +0100
In-Reply-To: <20121215204226.GA2870@herton-Z68MA-D2H-B3>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-163-git-send-email-herton.krzesinski@canonical.com>
	 <1355601558.18807.28.camel@deadeye.wl.decadent.org.uk>
	 <20121215204226.GA2870@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-upnhBIhfulUqBY9lWS3O"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.219.247
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-upnhBIhfulUqBY9lWS3O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-12-15 at 18:42 -0200, Herton Ronaldo Krzesinski wrote:
> On Sat, Dec 15, 2012 at 07:59:18PM +0000, Ben Hutchings wrote:
> > On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> > > 3.5.7.2 -stable review patch.  If anyone has any objections, please l=
et me know.
> > >=20
> > > ------------------
> > >=20
> > > From: Marcos Chaparro <marcos@mrkindustries.com.ar>
> > >=20
> > > commit acd9454433e28c1a365d8b069813c35c1c3a8ac3 upstream.
> > >=20
> > > Added Atheros AR3011 internal bluetooth device found in Sony VAIO VPC=
EH to the
> > > devices list.
> > > Before this, the bluetooth module was identified as an Foxconn / Hai =
bluetooth
> > > device [0489:e027], now it claims to be an AtherosAR3011 Bluetooth
> > > [0cf3:3005].
> > [...]
> >=20
> > This seems to be applicable to 3.{0,2,4,6}.y as well...
>=20
> While we're here you may also want to consider to add to other stables th=
e
> following (where applicable, I didn't verify exactly which versions these
> may be needed):
>=20
> [163/241] drm/i915: EBUSY status handling added to i915_gem_fault().
> (reference: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087302)
>=20
> [164/241] MISC: hpilo, remove pci_disable_device
> (reference: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087860)
>=20
> This is what I recall as bugfixes requested to be added directly to me,
> but that didn't yet came through as an stable mailing list request.

I've queued these all up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-upnhBIhfulUqBY9lWS3O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNyVVue/yOyVhhEJAQqE2w/9HnbC9IYnzCTRD/TtBmc+1Qgd6/Fvg/UG
gFqRkCgs7DiQBBPhevbd4upFe/fP13aL7FVdVQCHyTc2NM6aVejoOYreeg/tCHVr
WQfR695aviCTZtcHm6jupNBNI7nQJBnemdKxWCbRliR3sm9eRtzjL7sNnvKlz2sW
9TxNgVUVmuFB0N8QG67duTYCLK01UVXnv4cNDyjSdVOCplaTDHzNmC9MTZHeOcf2
8NDMWWIZTck/FRuEWw8dB0WmtS/8JuzKUHqT6p7vRTp7Owrg47oNwLBiEZMtfJdc
0Tv5ctwroGU7cuVw0hfxKrFmg/YzYl01w6S/o+4qWowWK7RrIl2Vj6qwJN8/p8PG
a5UpfuokDU7098LNQuVbJy1LCFerAg6nWOfy3P1s8/QY58J7mAubhJkoSaW4tJwT
ZHBidxsDH1Ir4ZfCm9UwkLJc+7hSjYWJ70R8uqM8WvwDG/D5IA0eL1XVYc1h29ke
fBaKm9cpxlgLEsWYBmvpnce/fAdzqsz+apXfhhp53EL8XlHGidLRxaWUpOf3ItlN
LWE3EuCilTD74tdRhns2N0ujVROEzIMuE8EINTTdzXECuOBWXad2rWcJKgMgU1/3
cQeQeHeysJr720pQKYV0YqCxFCXMoQZQiHRHnNbMwx6hTrdpoqc8su57Q9g4uTcE
xpmrh4zN8kE=
=y5Fz
-----END PGP SIGNATURE-----

--=-upnhBIhfulUqBY9lWS3O--
