Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab2FQOFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 10:05:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48302 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757334Ab2FQOFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 10:05:02 -0400
Message-ID: <1339941892.4942.231.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/82] 3.2.20-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Sun, 17 Jun 2012 15:04:52 +0100
In-Reply-To: <4FD4D146.80804@gmail.com>
References: <20120608041840.861504477@decadent.org.uk>
	  <4FD2012F.60309@gmail.com>
	  <1339164246.21665.119.camel@deadeye.wl.decadent.org.uk>
	 <1339196050.21665.128.camel@deadeye.wl.decadent.org.uk>
	 <4FD4D146.80804@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mHCp9Jiu2mViPPUCNdx2"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mHCp9Jiu2mViPPUCNdx2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-06-10 at 18:54 +0200, Maarten Lankhorst wrote:
> Hey,
>=20
> Op 09-06-12 00:54, Ben Hutchings schreef:
> > On Fri, 2012-06-08 at 15:04 +0100, Ben Hutchings wrote:
> >> On Fri, 2012-06-08 at 15:42 +0200, Maarten Lankhorst wrote:
> >>> Hey,
> >>>
> >>> Op 08-06-12 06:18, Ben Hutchings schreef:
> >>>> This is the start of the stable review cycle for the 3.2.20 release.
> >>>> There are 82 patches in this series, which will be posted as respons=
es
> >>>> to this one.  If anyone has any issues with these being applied, ple=
ase
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Sun Jun 10 13:00:00 UTC 2012.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> A combined patch relative to 3.2.19 will be posted as an additional
> >>>> response to this, and the diffstat can be found below.
> >>> Is it too late to nominate patches?
> >> [...]
> >>
> >> It's too late for this time, unless there's something really urgent or
> >> needed to avoid some other change in the rc causing a regression.
> >>
> >> I'll queue these up after 3.2.20.
> > I'm sorry, I see you already requested these earlier.  So I should have
> > queued them, but anyway it turns out that the last one (commit
> > a6a17859f1bdf607650ee055101f54c5f207762b, 'drm/nouveau/disp: fix
> > dithering not being enabled on some eDP macbooks') breaks the build:
> >
> >   CC [M]  drivers/gpu/drm/nouveau/nouveau_connector.o
> > drivers/gpu/drm/nouveau/nouveau_connector.c: In function =E2=80=98nouve=
au_connector_detect_depth=E2=80=99:
> > drivers/gpu/drm/nouveau/nouveau_connector.c:620:18: error: =E2=80=98str=
uct nouveau_connector=E2=80=99 has no member named =E2=80=98type=E2=80=99
> >
> > So you'll need to provide a backported version of that.
> >
> You're right, with some digging it seems to have been renamed between 3.2
> and 3.4, I'm sorry for the inconvenience.
> Changing nv_connector->type to nv_connector->dcb->type fixes things,
> it seems nouveau_connector and nouveau_encoder both have that same
> member with different meaning on older versions until a rework,
> so here's it fixed:
[...]

I've added all 3 to the queue, thanks.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-mHCp9Jiu2mViPPUCNdx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT93kBOe/yOyVhhEJAQpr8BAAwNfN8+Q45DdVkiKqVLrLCvgAGkYopXzK
tA3b0ZxG7T158cOHTDmqz3SmhGBwX8Mpl1LrDJNuYJ80D7H2usM1TwnE+J1zjPI5
kv2nwMI9T5rQanmFqnoVruxKO+n1KIaFStO6/1mtM9xy9bXTbZTzvHi6dK3pbrOE
IZnuS2hhSoiIWI2rQrVvHARiP4iiM7SdJGa5PKXA8pIG5w5Ex73CFuEyuL4HQE3B
0l6qJUkh45EpW5ZHqIIBGFBcgIqTBS7mCEJ4swnWR8HjaHPhrUGsrv+jvlVUWpxf
v5v4dpd2p2P6+K8b2gXeIZHWUl/zzFZS6KOjtE+mWWv8p3EJs31as4emBHEJdxyd
A6aCAN4txfpMR40f5BTd8C9ZNPjrORQ3NnJFveFgCjj0zpHAH30of3DS+4rDub7l
8iofzvKwBl1Tvm3N7BI6h9pQCnimEEtxTRmSam5RX4zlLgstgu1z3YvV9ZJNoiCO
QYf3It9HflXwjD/m73WRaXiEGr/J+NoLjlDoZnVyxidNhnfm3AO5P0RlGpRbDeSF
2icYpNLtOXsJCJFKeflAg+mZ7hCp+nEkwaP0pEHqeYdZxo0SdxGHJZ08nR1/qq8l
Jr9mVF5ZLOVYzQXKW1r7jvBk8Hdub+TxN7RokSyDc4BKEYe2t23T6OfLSj3JPDi8
ULi4LyWjkbM=
=E6FW
-----END PGP SIGNATURE-----

--=-mHCp9Jiu2mViPPUCNdx2--
