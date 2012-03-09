Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2CIMbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:31:46 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:54084 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074Ab2CIMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:31:45 -0500
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 omap_dss2 tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
In-Reply-To: <201203091226.53749.arnd@arndb.de>
References: <20120308170048.f1a992bca2ca2d93fa9747bf@canb.auug.org.au>
	 <201203091150.11294.arnd@arndb.de> <1331295269.1927.54.camel@deskari>
	 <201203091226.53749.arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PoObmaZrQciMIimtg12k"
Date: Fri, 09 Mar 2012 14:31:41 +0200
Message-ID: <1331296301.1927.64.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PoObmaZrQciMIimtg12k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-09 at 12:26 +0000, Arnd Bergmann wrote:
> On Friday 09 March 2012, Tomi Valkeinen wrote:

> > Merging omapdss tree through arm-soc would make sense for avoiding
> > conflicts, because almost every merge window there are some conflicts a=
s
> > I often need to edit arch/arm files also. But I'm not sure if we have
> > ever had a conflict in drivers/video.
> >=20
> > But still, it's a video driver, and fbdev tree sounds more suited for a
> > video driver.
> >=20
> > So I don't know =3D). Basically it's ok for me either way also. But it
> > would be nice to have a standard way of doing this, instead of, for
> > example, merging omapdss sometimes through fbdev, sometimes through
> > arm-soc, depending on the conflicts...
>=20
> Actually, I did not suggest omapdss through arm-soc, the idea was that
> that the same branch gets merged into both the fbdev and the arm-soc
> trees and let the fbdev tree go to Linus first.

Ah, right, now I see. This sounds ok to me. I'll cc you when I send the
pull request to Florian (presuming the arrangement is fine for him).

 Tomi


--=-PoObmaZrQciMIimtg12k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWfgsAAoJEPo9qoy8lh71crgP/0y/dhNS79/jENlxxuqmjGoN
3v7jcLCCzIfwPtcOO7CTUlyeLbfxEAG5pKcQ5vbAmBdb0/XJ11aY/BUqM2Su/zwr
jUO28KP1NqR5abhii1RDXS4/+RZXjRyMwFZpHJbuGUG2eNj9xCszqTgokhQ/6iNo
KYxJRGU05LC9S4Yi8X9JW3TJy/UO81Q7LVs1RRot3M7sQLIsJXmWbhi8APFkJOaZ
46ug0PlO9/5yMHFMxQmt1G+Zf3S87iYdlysAebNnY436EA1mKBVwRDUl9c5TILCt
ocXtj5Jb0imcf17X/nkpjnBwX159zgvd4Tn31PbHeRnpdJuScPr7tgwYqbpj2IQH
yBwCXQ+h3aydZmk5C02Xo0OyLeZAdVT7EQLFyRzvBUekuwfP21DAJ4+F6nRfzJN8
C+ID6nyqdiajiavIUr/E8tRrxNhPMuDFabPPC/WeM7VHz+InyRfG7CJehp4WxYH0
UhFgPKeVtL9Az8I+8H69gE/V/CAjE3gpJFmWJ2DfcPQFFh8Fag1GcgY2zS2iu9Im
8pZ8zFr4PKSxY75Mtp/0OJQplsMb8A3vu4CLPiKCX+YQCZ/mnOSFajtETDqcVYup
+TQalKSTWU0n1/EqU8Rw8NSF9oyA+WxRrcWDHehuUdUkVf0+I2YnONXksm/T4zdM
7qDi9nvbOh/EKyTxXIn5
=Bq0n
-----END PGP SIGNATURE-----

--=-PoObmaZrQciMIimtg12k--

