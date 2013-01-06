Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3AFJBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:01:20 -0500
Received: from contumacia.investici.org ([178.255.144.35]:33959 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3AFJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:01:18 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 contumacia.investici.org 3C280E8B81
Date: Sun, 6 Jan 2013 10:00:17 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH -v2 19/26] batman-adv: rename random32() to prandom_u32()
Message-ID: <20130106090016.GF27589@ritirata.org>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
 <1357215562-6288-20-git-send-email-akinobu.mita@gmail.com>
 <20130104021252.GE27589@ritirata.org>
 <CAC5umyhLB++mh=-pFRzhD-YxZH2RwC5ED4g8mYxS5pYGcbxsvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
In-Reply-To: <CAC5umyhLB++mh=-pFRzhD-YxZH2RwC5ED4g8mYxS5pYGcbxsvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 04, 2013 at 10:50:41PM +0900, Akinobu Mita wrote:
> 2013/1/4 Antonio Quartulli <ordex@autistici.org>:
> > On Thu, Jan 03, 2013 at 09:19:15PM +0900, Akinobu Mita wrote:
> >> Use more preferable function name which implies using a pseudo-random
> >> number generator.
> >>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> Acked-by: Antonio Quartulli <ordex@autistici.org>
> >> Cc: Marek Lindner <lindner_marek@yahoo.de>
> >> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> >> Cc: Antonio Quartulli <ordex@autistici.org>
> >> Cc: b.a.t.m.a.n@lists.open-mesh.org
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: netdev@vger.kernel.org
> >> ---
> >
> > Hello Akinobu,
> >
> > as you can see in <201301021952.49979.lindner_marek@yahoo.de>, Marek Li=
ndner
> > already applied this change onto our tree. You didn't need to resend th=
is patch
> > to netdev, it will be sent by us through a future pull request.
>=20
> Yes. I read Marek's email. But I included it in v2 again in order not
> to break the build. Because it doesn't show up the latest linux-next yet
> and the last patch 26/26 removes random32() and srandom32().
>=20
> But I should have mentioned it and trimmed the Cc list.
> Sorry for the confusion.

Ok..everything is fine as soon David won't apply this patch.
Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ6T0gAAoJEADl0hg6qKeORmoP/0ufdpjCTS3JAqZTBxhxztqA
66ijELkVTinlb5XENn72cTm3kSvFzacZN0+nOFyW+MiQ34xCuuvZPeKSHZPa5fdF
YBbWX8+KZPBVKRekMFv12P8wRuh3FBIHF9tnJE//uZ98w5GKyrCjSlC58kLf1Xqy
2jssHcPi/fsqHzjxF7V7NdZV5PtrekUtjyddwmH2pAicpcbwWWpmO4FZH6DkPcho
lR8tbXJh/I3bDo8Qrwk0wW6yAuFduiAwYwXkOOKoTuauq25tP+9VwrU4/yrcl7Fp
JJWHHgUsAAMu/saey22dGR8fckGBYRcxBsuk080vsQ82lsbII5nx9NSDFOsZLyW2
uVbQLZEeERrwPLbovabPwb+rre9QgaW0x57vPpkm5EwJa/0ukO7ojUrymoKhiGcr
kHVNmO633vq+yM2/IYxpAaWGEViuFr0hFkg/9PXqRjUzbnOBLVThUYKqwOO0LIq2
ILA7mEknuQxToFGS3uujxroRRsvTEEh0lOwEJQsOwqzCr61zzPBcAaQbyhONmpnz
bHOAxQcgbuvkCH3x9RknfyPpbJlg/J/ezdG2BV7lsgirBNMLE+7d6xNB0IG6SXyc
CCiVRMFS5Lbp/1RF0KBEAvKiVm+m5X55BcIy1KPr0cFzyAxZy6cRoH3u6TvAp8xn
dAjmVFueY0eZ0lj8yOzQ
=VonP
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--
