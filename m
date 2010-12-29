Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab0L2KAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 05:00:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50467 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab0L2KAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 05:00:52 -0500
Date: Wed, 29 Dec 2010 21:00:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 29
Message-Id: <20101229210045.f583c18d.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimHgKKw8eeH==YYY_Z9keewxamfOpRzLVDgKxv6@mail.gmail.com>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au>
	<AANLkTimHgKKw8eeH==YYY_Z9keewxamfOpRzLVDgKxv6@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Dec_2010_21_00_45_+1100_OkMLQweS=K0_pN7Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Dec_2010_21_00_45_+1100_OkMLQweS=K0_pN7Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Wed, 29 Dec 2010 10:54:28 +0100 Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>
> What is the recommended way in case of these "comparison" warnings?
> Send to whom/where?

Their respective maintainers (see scripts/get_maintainer.pl), unless you
can also identify the commit that introduced the warning, then you should
also cc author(s),

Thanks
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Dec_2010_21_00_45_+1100_OkMLQweS=K0_pN7Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGwbNAAoJEDMEi1NhKgbs4nIH/iTFx7jwT0er6heOi6LLyEtl
2acEBBwf8x7NkCLyx8W2few1ORyt1iZWCKoICTS/4+7Tr6VKj/FOc+KUGU+LWJq4
N86X9HRFxKMSk9FxvOZ2cI2sqNqQS7njWHjmtyar3ruWI2kjf/p29jmtLs3m/k2X
oq5tRDebUI5wRYVst8odgtfkG2gRtiZpVb/36bS6tA+6SsFBpyRCxPapaJQz/dAJ
OmLK4yPOms9DYnB/RoR6Wjs2p0KJP2CG5zVhIrVviX/YOVWkuMepy4rXbvhu39hi
s2D7aFmo63smzp2A/5zGN0cthmR2NZdkMNxsTCtT8p9ur9u0Z7hYI96fz06RKik=
=Pmi+
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Dec_2010_21_00_45_+1100_OkMLQweS=K0_pN7Y--
