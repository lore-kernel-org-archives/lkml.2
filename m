Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2DLEzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:55:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33989 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754587Ab2DLEzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:55:18 -0400
Message-ID: <1334206506.7150.386.camel@deadeye>
Subject: Re: [ 06/59] Fix non TBI PHY access; a bad merge undid bug fix in a
 previous commit.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 12 Apr 2012 05:55:06 +0100
In-Reply-To: <20120411231036.581670888@linuxfoundation.org>
References: <20120411231036.581670888@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QDnYEsnZZFpPF0ALgCPT"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QDnYEsnZZFpPF0ALgCPT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-11 at 16:10 -0700, Greg KH wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
>=20
> From: Kenth Eriksson <kenth.eriksson@transmode.com>
>=20
> [ Upstream commit 464b57da56910c8737ede75ad820b9a7afc46b3e ]
>=20
> The merge done in commit b26e478f undid bug fix in commit c3e072f8
> ("net: fsl_pq_mdio: fix non tbi phy access"), with the result that non
> TBI (e.g. MDIO) PHYs cannot be accessed.
[...]

This doesn't look relevant to 3.2.

$ git describe --contains b26e478f
v3.3-rc1~182^2~207
$ git describe --contains c3e072f8
v3.3-rc1~182^2~598
$ git show c3e072f8 | head -8
commit c3e072f8a6c5625028531c40ec65f7e301531be2
Author: Baruch Siach <baruch@tkos.co.il>
Date:   Mon Nov 14 08:21:30 2011 +0200

    net: fsl_pq_mdio: fix non tbi phy access
   =20
    Since 952c5ca1 (fsl_pq_mdio: Clean up tbi address configuration) .probe=
 returns
    -EBUSY when the "tbi-phy" node is missing. Fix this.
$ git describe --contains 952c5ca1
v3.3-rc1~182^2~603
$ git rev-list v3.2..v3.2.14 drivers/net/ethernet/freescale/fsl_pq_mdio.c
$

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-QDnYEsnZZFpPF0ALgCPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4ZgKue/yOyVhhEJAQp7TBAAuntyjATnpM5Hn/6Tmmby1NkFsVrLJRNa
yP5mPNaHMf7Y7uFmWijuav9WbuXvM3yVHWafTmJS+gxkQZk3afbNvfTuFT17YdBj
u0czpWnJxSHSEj3AG3hpqdFL//Z2g+Lq/1+l3nJokhno+dTUtVYtyPM1/PshRe3L
TLAaFP8uEFI/7TJLT+Yq/6WUzsBPmM1T+Mq752KsGyX7ZmyBtR5q87bSQd8V7ndY
VB5fAZQGdRcLS2aisfNtQVEzXViuts3qOx1QXv125qKQ/PhktiWazUajVKGfoMR6
YO/JwzaZmfCb+TkQS+qqN9J14ycBoOhmRyrZjymU6xKUP/yl9Y5N+SncLIfmKalk
oxQlibdTJjLL959CdXF2FXxcUesqqjxyCoUBr1SIBlsyRa8krPxt8Q7oaeOlswVO
HS6Og1i83Z3MlbCeVtAwr9GVphFXTPyLF8rMlWhkT8QyUUmQF2ZAMfCgHCurXHN7
dw36udX/hLA9QHIFD+LWRiLFz0UKZL0KkDdUamvX0752P6bCygEeiv95aQAjPe2e
kgGhe+8u19eQc9Zn5SVXlpd/4fm40VntanTXnM5GKnFFb8TzJcnLbAKB1bGY0T0a
5We/TEffPGhFY5uoZD4wFpt2oOkgy/TCglYZGmViJLBoDsq1U4YVWafe+fXs5lur
hkYaq8h7+Cw=
=vSnW
-----END PGP SIGNATURE-----

--=-QDnYEsnZZFpPF0ALgCPT--
