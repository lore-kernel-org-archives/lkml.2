Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2FIM4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:56:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56438 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab2FIM4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:56:32 -0400
Message-ID: <1339246581.21665.150.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
From: Ben Hutchings <ben@decadent.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Sat, 09 Jun 2012 13:56:21 +0100
In-Reply-To: <20120609023017.GB14153@thunk.org>
References: <20120607040345.775333506@linuxfoundation.org>
	 <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
	 <20120608031144.GA9722@thunk.org>
	 <1339125708.21665.108.camel@deadeye.wl.decadent.org.uk>
	 <20120608200553.GA1704@thunk.org>
	 <1339196476.21665.130.camel@deadeye.wl.decadent.org.uk>
	 <20120609023017.GB14153@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wvBLwyRsmcgJA+Xkp+ph"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wvBLwyRsmcgJA+Xkp+ph
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-08 at 22:30 -0400, Ted Ts'o wrote:
> On Sat, Jun 09, 2012 at 12:01:16AM +0100, Ben Hutchings wrote:
> > > Um, very good point.  So we should either drop this commit and wait
> > > until the next stable release, or also pull commit b22b1f178f6 in as
> > > well.  Basically, this commit and b22b1f178f6 should appear in the
> > > same stable release.
> >=20
> > I've (re-)queued them both for 3.2.20.
>=20
> Hey Ben,
>=20
> If you haven't also queued b0dd6b70f0 (ext4: fix the free blocks
> calculation for ext3 file systems w/ uninit_bg) could you do me a
> favor and also include that in 3.2.20?  I'd really like to get that
> into various distro kernels as quickly as possible.  (i.e., Debian,
> et. al.)

Hmm, OK, that looks pretty serious.

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-wvBLwyRsmcgJA+Xkp+ph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9NH9ee/yOyVhhEJAQrQxA/+JPK9SFm4MXwcZ6Y5ldec5Pxxq1ZSX4zn
lHn52VQ3GT4hA/zsA0zhcF9X3aX8h0BN1PWTYz00DFpQRdu871kYQayCC1xbBQNa
1Iq596SDfUYZ0lFH9vBpYJ/9iyHSbSE7ebzZwLikktxAPak+IKKKjsDafsE7QPWG
TtottTlmzuIuL+Vsj2bDpqqJwEhbO2gNiLd7Zxo1Zwf7g59hJSBre91ktjV3U0Fi
Egdd2K3Th0JxY0LiDqFvD8hsdSoMnjHLbYr3QF4z3R4HyJm6nH67VrG7ji1it8vY
vXbv5uU3cmJX7HGijrwXmlrLUn2m8YUWkIlJaViY+v1SiJe4Vflr5FslLJPKtnMg
+MPXfBg8QsHxsIdoF3MpURiGsV5CzWh16pruNzEbHKT1PlOdUKaEKC7GqcQacUnd
2Tcbw4g026EhtICIUky5ipRRH+D9BzbsYT2dE8iOP+Q3QRYH3Z0w6v9QmVfZ1yog
z/Zm0vP2sgRTP1uctKkuSaeuyaArvxWKuYsA2ZniT6hpwm0bc30J+qxfis7kV8v1
ibDDAkUSN9mpcJe+3lHD4Lm/4IicT2YQh+mmibgbY8xPnyvS++kWIgy/N1Oim6vG
hKgXO4lOHmwduWa71LvdVpiaTVwo8LB11DSWGS0s9GCZDCKBV2IAZaCESEM0XEpW
jC6Gs3wQyJs=
=HMm9
-----END PGP SIGNATURE-----

--=-wvBLwyRsmcgJA+Xkp+ph--
