Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2FHOEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:04:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47331 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933478Ab2FHOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:04:15 -0400
Message-ID: <1339164246.21665.119.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/82] 3.2.20-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Fri, 08 Jun 2012 15:04:06 +0100
In-Reply-To: <4FD2012F.60309@gmail.com>
References: <20120608041840.861504477@decadent.org.uk>
	 <4FD2012F.60309@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RdvHr/UGGBXMJ9Ak+r1h"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RdvHr/UGGBXMJ9Ak+r1h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-08 at 15:42 +0200, Maarten Lankhorst wrote:
> Hey,
>=20
> Op 08-06-12 06:18, Ben Hutchings schreef:
> > This is the start of the stable review cycle for the 3.2.20 release.
> > There are 82 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Jun 10 13:00:00 UTC 2012.
> > Anything received after that time might be too late.
> >
> > A combined patch relative to 3.2.19 will be posted as an additional
> > response to this, and the diffstat can be found below.
> Is it too late to nominate patches?
[...]

It's too late for this time, unless there's something really urgent or
needed to avoid some other change in the rc causing a regression.

I'll queue these up after 3.2.20.

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-RdvHr/UGGBXMJ9Ak+r1h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9IGVue/yOyVhhEJAQp9MxAAxQm4M0SRB5mL7IX4kb6M5XKpxKnJn4Tx
syOfPuuaGOJtv9ugEalkwhM9MHvUgv6srL1xn9rggTldMTei5AWKefa4+f+GKXSj
jckvMjAsMtm8//tpIwNLVNrtCSJvVI3TwFQ/bUe775mEeYVXCOKWO9gxY6q3KmYA
7UMfp+w/IDZDROD4QxT7hueP05GS3AFw8X6kz7/3RUY0h/ae77/Sq3UYPptjymi2
e2/d+erH8C18yoNouRZBGevkiTyxBNBKiiMQIVZ0ijdMAB/9hOjgQGMHbnZGQN4N
tAVGG7aRIQ8EdQnpV/87klK8doPGiNVGtR1M6aYOg9PQ53Q4nMuZb1N1XGtqC1Ij
hTMScrZtHMkvKkg9IbRlQr5SM9NQnl4lxlBLaN0Ls329yIORwcQzvixNxbAhLeiv
2JZqrmRpTNA5WrcNSKDLGig5leFXtZ6kNuqq/T61ttX+0OFUNqlsQUaa91zOkdmv
/+xH7U7+u7oFnj0KFDmpxtDyLM1VNaZj09R1WNkWzgzN2z2kbJL0qfeD9EmNht8Q
nfFdLVUzg00rJF1px2NkbwYKBBLIcvTHi9mhuIBuGl8O3NBv2+9xMbQxhLwsX2TW
t1cLPT9dKUX3qzl34TIwBr+kbKALGuif1zEbTN89srYqnILYpapFARzrMpvQW4nI
g5+qP1RaUko=
=rlg4
-----END PGP SIGNATURE-----

--=-RdvHr/UGGBXMJ9Ak+r1h--
