Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2L3Mij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 07:38:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43716 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab2L3Mii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 07:38:38 -0500
Message-ID: <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Andreas Hartmann <andihartmann@01019freenet.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sun, 30 Dec 2012 13:38:19 +0100
In-Reply-To: <50DEA41E.6010409@01019freenet.de>
References: <20121228190352.097882544@decadent.org.uk>
	 <50DEA41E.6010409@01019freenet.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-h7ZkLaOLLPqZ5XAgkHjw"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h7ZkLaOLLPqZ5XAgkHjw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-12-29 at 09:04 +0100, Andreas Hartmann wrote:
> Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Andreas Hartmann <andihartmann@01019freenet.de>
> >=20
> > commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f upstream.
>=20
> [...]
>=20
> This patch is a workaround for
>=20
> mac80211: retry sending failed BAR frames later instead of tearing down
> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html -
> f0425beda4d404a6e751439b562100b902ba9c98)
> See:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=
=3D83304
>=20
>=20
> Meanwhile there was a bug report complaining about problems with
> be03d4a45 when used as STA:
> http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/1257
> You can find there a few other workaround proposals.
[...]

OK, I'll drop this for now.  Once this is sorted out, please send to
stable a complete list of fixes that are needed.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-h7ZkLaOLLPqZ5XAgkHjw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUOA1u+e/yOyVhhEJAQrWlhAAlAol9+KMDcvHv9ovs0URyg89sJ2HeEqG
A8OreqjLDgJAEVe3xcT+5Lut/3uFW2Mpd4PRijS15B2Ep1vuvombQpItaXj+Ox3P
PD5Bkm0D6lPUcvAB/oadgIt3TyHZ5XDCOkbbU42hDtfqMqdtSxhLRTKWSr8L+mg/
/NK8H5wRzt6Up4rHlznZ9ytgMUMJBzB4923pWyhXXN3gMMg2n9fuKFZRCye+XjWA
+rdjErK2kmJnfw8MsLp3sBoIq1dpmohiqbJWYnYpwbfJxlV2Q3X7aobQuGdzZdN4
60NxJUzGeN+Fih5lSJfSM+9qpKYA/mhZU8Y2887sfVyN6dk6kE9+0P3Kjaqsuper
gGjx6S7hrZ+dArBGennsZmnool8zZ20urEFStF/ffYNlzXKYMMTrDu78JUu0Y1zH
PkYoCWVamKGNG1YYhZjWrVChgOU7rwZ3q37dgywzb+M4EemBkDXGkSD43cYyfSrj
SqUIeoM8A8eKoyW3CrbwQ76U20sDG+rypIsOh+qlRaYnmB86vd67PezGwwI8wGpu
RqLBluTPiwm41bgm3fFJEmZtnTgo+RIc6kj5bb+lgk5R+lP/R0Y0UvucbutcB1ug
0XuwEqGF7ZFSSW0J6irNN7ZQz7jiqSsURUKyoajb5XaZK1rODQlbsdzXVnWlraLe
WTAE1EU+11Y=
=09Xi
-----END PGP SIGNATURE-----

--=-h7ZkLaOLLPqZ5XAgkHjw--
