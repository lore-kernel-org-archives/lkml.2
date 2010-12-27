Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0L0JMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 04:12:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51446 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0L0JME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 04:12:04 -0500
Date: Mon, 27 Dec 2010 20:11:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 27
Message-Id: <20101227201155.ee8cd1ab.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikbiART+SX_JwM=pcAg0NJffVgX1oU=aO42dmbC@mail.gmail.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	<AANLkTikbiART+SX_JwM=pcAg0NJffVgX1oU=aO42dmbC@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Dec_2010_20_11_55_+1100_U5BXPxPrHo/3sR4="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Dec_2010_20_11_55_+1100_U5BXPxPrHo/3sR4=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 27 Dec 2010 09:04:06 +0100 Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>
> Can you try to upload/push via IPADDR?

I can only upload to master.kernel.org, the rest is done by the mirroring
software.  I have no access to any of the other kernel.org machines.

> > The sound tree gained a build failure, so I used the version that would
> > have been in next-20101223.
>=20
> I thought there was no "next-20101223" :-).

That is why I said "would have been in" :-)

> Can you please upload the patch-diff to
> <http://www.kernel.org/pub/linux/kernel/v2.6/next/>?

If you mean for next-20101223, then there wasn't one.  I ran out of time
and just threw away what I had done.

If you mean generally, then (see above) it depends on the mirroring
software.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Dec_2010_20_11_55_+1100_U5BXPxPrHo/3sR4=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGFhbAAoJEDMEi1NhKgbscTsH/jowPJsG0O8xz30sC1FTmTfo
yjsM3cQ/FlImnhBFlV9N4PkiKX/U4/SRnKMX1Z4/3pU2nmQH4SpdlFgcVmi38mfz
ZUYlIR5shP33wsAabSi3HSrlDlyFwOALjmg6EokUK834OgggIRekjWx5IKHBNOQW
8rmYiLAi8KTSC61/ZqadhPi15Itc/+BfZTWjtRQPrD8EJ4CPZe+GGaTMf17uIeSe
73NdEu0Tvv6OpY1M8TuHicHI4yHYOUPNe+qNoJwQaV/MCjjiaW/3DYD6MFdl3UIu
0QOje2NKZo49vvmIyJTn5yMZ4RgCXzry1y6KYByTUfOAsfVE6KtrZP2dYdp76xU=
=Yfy7
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Dec_2010_20_11_55_+1100_U5BXPxPrHo/3sR4=--
