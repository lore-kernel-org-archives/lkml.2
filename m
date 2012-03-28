Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2C1PCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:02:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2C1PCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:02:39 -0400
Date: Wed, 28 Mar 2012 17:02:25 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        patrik.r.jakobsson@gmail.com, linux-kernel@vger.kernel.org,
        greg@kroah.com
Subject: Re: GMA500 support
Message-ID: <20120328150225.GA16450@avionic-0098.mockup.avionic-design.de>
References: <20111121182910.GA2856@Boggieman>
 <20111123112847.57c20f8f@lxorguk.ukuu.org.uk>
 <20120328132840.GA26353@avionic-0098.mockup.avionic-design.de>
 <20120328155336.41063e3a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20120328155336.41063e3a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:abcO7ITQAUBNBbitXAsPlYchfWHI8g/sTfRsOwP4/wk
 fqdSXGgSHOMWPoUxkYUgTZa4vEIYDmdKBKbYj6k8BQZG65oSYV
 kmh6iACMWIY48lYrmVRC4BQ6qx8Hja5Iu4Ykr9m/S11UfnwB/u
 gvX09zPqMLzRU5MFSroX4rEAFthia/iyZwXjiNaK0dwZ3nk5c+
 e7stZZEXgZKwZD/N3pE5glaemCvuHvI/ZuJPAhIwKmWUxrgwYg
 7NHXJVhBPXFMw/HLp9P/t9a/SaOxE4jX/ZiOaA4U18qUAddUim
 aFEtAHVh2WixXV2Bc9A2Ef7BiKCFonu075ERa9p2ngJXRpMrLX
 8wpXNjS4qFp19wj9Usckj8NzOMxjIup/dYZ4t8thdY2ilM7Avj
 vpLJsCo2ZrqzPyQKWol2D8YqLOUjczCBXc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Alan Cox wrote:
> > From a quick look this seems to be developed for Poulsbo, but since you
> > mention GMA600 explicitly, is it supposed to work on newer hardware as
> > well? I'm specifically interested in the Atom N2600 which has a GMA3600
> > (0x8086:0x0be1 to be exact).
>=20
> I believe there are GMA600 and 3600 bits buried in the packages for
> Maemo/Meego/Tizen vaapi code but I've not looked.
>=20
> > I'm also not sure which kernel driver this was developed against. It
> > looks like it might have been against the initial staging variant. At
> > least it still has some references to TTM, so I guess anyone wanting to
> > port it to the new kernel driver would have to convert those to GEM.
>=20
> The one for the 3D/2D non-free user space driver. I've been working on
> Cedartrail primarily at the moment so not had time to dig further into
> the video playback logic. I did get the decoder detected and mapped
> happily but haven't yet had time to persuade the firmware to upload.
>=20
> It'll also need the driver extending to support the overlay planes
> feature in the DRI/DRM layer.
>=20
> > Do you think that would be doable? Can you say if the GMA3600 is
> > sufficiently similar to make that driver work
>=20
> I don't know for sure.

Thanks, I'll dig some more.

Thierry

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk9zKAEACgkQZ+BJyKLjJp/uJACeJaXHy/vs5DPnoYwuvlljz/x8
2aEAniomK6S0SO6VrDz+7+nwHmU19V0e
=n1e7
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
