Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab2DLPCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:02:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38040 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932093Ab2DLPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:02:20 -0400
Message-ID: <1334242922.7150.387.camel@deadeye>
Subject: Re: [ 06/59] Fix non TBI PHY access; a bad merge undid bug fix in a
 previous commit.
From: Ben Hutchings <ben@decadent.org.uk>
To: Kenth Eriksson <kenth.eriksson@transmode.com>
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Date: Thu, 12 Apr 2012 16:02:02 +0100
In-Reply-To: <OFFBE17A27.42E05B7A-ONC12579DE.00262282-C12579DE.0026AD98@transmode.se>
References: <20120411231036.581670888@linuxfoundation.org>
	 <1334206506.7150.386.camel@deadeye>
	 <OFFBE17A27.42E05B7A-ONC12579DE.00262282-C12579DE.0026AD98@transmode.se>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Vu2M7kSFm+g8uhqvIPpE"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Vu2M7kSFm+g8uhqvIPpE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-04-12 at 09:02 +0200, Kenth Eriksson wrote:
> Ben Hutchings <ben@decadent.org.uk> wrote on 2012/04/12 06:55:06:
>=20
> > From: Ben Hutchings <ben@decadent.org.uk>=20
> > To: Greg KH <gregkh@linuxfoundation.org>=20
> > Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
> torvalds@linux-
> > foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
> Kenth=20
> > Eriksson <kenth.eriksson@transmode.com>, "David S. Miller"
> <davem@davemloft.net>=20
> > Date: 2012/04/12 06:55=20
> > Subject: Re: [ 06/59] Fix non TBI PHY access; a bad merge undid bug
> fix in a=20
> > previous commit.=20
> >=20
> > On Wed, 2012-04-11 at 16:10 -0700, Greg KH wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let
> me know.
> > >=20
> > > ------------------
> > >=20
> > >=20
> > > From: Kenth Eriksson <kenth.eriksson@transmode.com>
> > >=20
> > > [ Upstream commit 464b57da56910c8737ede75ad820b9a7afc46b3e ]
> > >=20
> > > The merge done in commit b26e478f undid bug fix in commit c3e072f8
> > > ("net: fsl_pq_mdio: fix non tbi phy access"), with the result that
> non
> > > TBI (e.g. MDIO) PHYs cannot be accessed.
> > [...]
> >=20
> > This doesn't look relevant to 3.2.
> >=20
> > $ git describe --contains b26e478f
> > v3.3-rc1~182^2~207
> > $ git describe --contains c3e072f8
> > v3.3-rc1~182^2~598
> > $ git show c3e072f8 | head -8
> > commit c3e072f8a6c5625028531c40ec65f7e301531be2
> > Author: Baruch Siach <baruch@tkos.co.il>
> > Date:   Mon Nov 14 08:21:30 2011 +0200
> >=20
> >     net: fsl_pq_mdio: fix non tbi phy access
> >    =20
> >     Since 952c5ca1 (fsl_pq_mdio: Clean up tbi address
> configuration) .probe returns
> >     -EBUSY when the "tbi-phy" node is missing. Fix this.
> > $ git describe --contains 952c5ca1
> > v3.3-rc1~182^2~603
> > $ git rev-list v3.2..v3.2.14
> drivers/net/ethernet/freescale/fsl_pq_mdio.c
> > $
> >=20
>=20
> The error is present in 3.2 as well, but the patch may not apply. 3.3
> contains both a fix for the error:=20
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dc=
ommit;h=3Dc3e072f8a6c5625028531c40ec65f7e301531be2=20
>=20
> and a bad merge.=20

So it wasn't actually introduced by 952c5ca1?

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-Vu2M7kSFm+g8uhqvIPpE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4buaue/yOyVhhEJAQok2w//QcL5MyUhxpyLitBW1g1Ox+2ayK0Eb/Ov
Vg32zGyHqwnMwEwLrPK7XdSnTYn0QxGTp+kMSe3S8xmWhhl4AoeA5ZW84YhPjzDX
lj2wTbzoBd6O1xW/kygN71IOlMfw5aR1CpTETAY50nit7X3MmQbXKureYEU3QVl8
Zgx5/9ieN7P3UZt04SydquhIxd25JQ3Cfgzi+vsf2BKYlon9AhZuq7yIavWXM6IB
MbxL89yra69WQXSZDT9dQmeGzyPNhZbhlx6xwGGjT0hnzY8m6HpGKraf0kKYnoi1
XupTkPdJrkGKBd5EZRxsqcVIvxtiAyPMkQyYswJpDf6VdW5/rER/l6noPNJOMgUg
T/2KG07w+mV3+y7F5g7eSODUmeWPHUbmDUO7xDMEUXlJtsTuDlcNEmZCEGu6z83s
DAb1MfiPV+2JZX+KCakcjmU6JW1Awrl40m79CcD0pMQuY7Mv7KhvdE+/QjbxcNwO
YLCjOBEjW/t/FroS7z67qs70tGbD+21pyN2YW1xf7bJfNV6c4ptuml/Rv2xPUw8o
rK+ZJH3sjKIzeeU4/KFV9H25VKnJkEA2dCKw3r75EQjnvXwcmODY0mjA/ttlDXu/
XLewkYm1z6rvFkedVAkagSFkKqnfqhlz1cYbpXXzhV26hIAb4mvLoxljocYRB0h6
5jHvb6l2dJE=
=WH3m
-----END PGP SIGNATURE-----

--=-Vu2M7kSFm+g8uhqvIPpE--
