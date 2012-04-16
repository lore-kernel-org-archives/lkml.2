Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2DPAc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 20:32:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41822 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474Ab2DPAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 20:32:27 -0400
Message-ID: <1334536331.3209.33.camel@deadeye>
Subject: Re: [ 06/59] Fix non TBI PHY access; a bad merge undid bug fix in a
 previous commit.
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        "David S. Miller" <davem@davemloft.net>, afleming@freescale.com
Date: Mon, 16 Apr 2012 01:32:11 +0100
In-Reply-To: <CAP=VYLp6F3YB_71aX=FxLf_dz7kzs-W+dPcA4OmC0VV0kQteiw@mail.gmail.com>
References: <20120411231036.581670888@linuxfoundation.org>
	 <1334206506.7150.386.camel@deadeye>
	 <CAP=VYLp6F3YB_71aX=FxLf_dz7kzs-W+dPcA4OmC0VV0kQteiw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-C9FrTJhhr3V+cK87F+RN"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C9FrTJhhr3V+cK87F+RN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-04-15 at 20:16 -0400, Paul Gortmaker wrote:
> On Thu, Apr 12, 2012 at 12:55 AM, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> > On Wed, 2012-04-11 at 16:10 -0700, Greg KH wrote:
> >> 3.2-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >>
> >> From: Kenth Eriksson <kenth.eriksson@transmode.com>
> >>
> >> [ Upstream commit 464b57da56910c8737ede75ad820b9a7afc46b3e ]
> >>
> >> The merge done in commit b26e478f undid bug fix in commit c3e072f8
> >> ("net: fsl_pq_mdio: fix non tbi phy access"), with the result that non
> >> TBI (e.g. MDIO) PHYs cannot be accessed.
> > [...]
> >
> > This doesn't look relevant to 3.2.
> >
> > $ git describe --contains b26e478f
> > v3.3-rc1~182^2~207
> > $ git describe --contains c3e072f8
> > v3.3-rc1~182^2~598
> > $ git show c3e072f8 | head -8
> > commit c3e072f8a6c5625028531c40ec65f7e301531be2
> > Author: Baruch Siach <baruch@tkos.co.il>
> > Date:   Mon Nov 14 08:21:30 2011 +0200
> >
> >    net: fsl_pq_mdio: fix non tbi phy access
> >
> >    Since 952c5ca1 (fsl_pq_mdio: Clean up tbi address configuration) .pr=
obe returns
> >    -EBUSY when the "tbi-phy" node is missing. Fix this.
> > $ git describe --contains 952c5ca1
> > v3.3-rc1~182^2~603
> > $ git rev-list v3.2..v3.2.14 drivers/net/ethernet/freescale/fsl_pq_mdio=
.c
>=20
> I think 952c5ca1 is a red herring;  What is called out as the regression
> commit appeared in tree earlier than that as 28d8ea2d568.

I see, the same patch was applied on two different branches and one of
those got into 3.2.

This fix was included in 3.2.15 despite my objection, so everyone should
be happy now.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-C9FrTJhhr3V+cK87F+RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4toi+e/yOyVhhEJAQrBqA/+PWg1evVCxJRbjFtZcHDanepHZqEk8Bf6
Si+aVl6f4ZpErFO0PCgQHi5JD2/aKEkrWrzEcN06Cbyg9CvpgoEGfUMYsFzys9lC
0rYarzbPFKAIMUkt5EI/mQY5rAGsPpKflnkF2jnHHVDZlicbudVBmDsoZqeQfpAR
ffTbeM+05vSDUAa+piX4VoZJHgLbcUmsNbaEI9iGEA/ovtbVziApbD1awn9H1YiA
AuSD6sP9EoEMKKgLfbKYA5JRj7elau5rY9mmlPbPAlS4tev+D+ac1bQtc+Y1KlfC
/RFhxJA0DB1Wj+O74hjmyRP000Yr5nJRl8GjmMCnG70oj7dYiwgcZwO7KRAmPK7F
iQdAfSd0Ucu08/+GeGLKLtH4r238IzH7fGMA4BAm1AFpAEOy/vekvAXez5V7cMuZ
kqJ6B11t2WBSV3KsaQr7fMDTcXYZ+GFrEPYWn3+1BI29yyHrz6r588gKHwrd1lUQ
oeDMBdSg2Q5TdhjQHtdA2UKfHZ1V1iXwxr3QCJNhPXzBDXUW9Gzmf3g1YrWWwYZX
lFvycvQIJP5eZ0HJOzg8DQYwUaixmFpn7icKQkgUlf39texcbKw1qSsrKo6Kqped
j8bLhDFATtcJZFUxesxd4DYX05Uc27cCaplfNR2lIVSKu4+ELyb6qNJX+EaWF+UI
yRLs5RiiywA=
=rYwB
-----END PGP SIGNATURE-----

--=-C9FrTJhhr3V+cK87F+RN--
