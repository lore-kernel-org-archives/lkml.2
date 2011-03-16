Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1CPXcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:32:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41592 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1CPXcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:32:25 -0400
Date: Thu, 17 Mar 2011 10:32:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20110317103218.ca7f63bf.sfr@canb.auug.org.au>
In-Reply-To: <20110314161919.15e6d983.sfr@canb.auug.org.au>
References: <20110314161919.15e6d983.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Mar_2011_10_32_18_+1100_Os3_oUDzLFVHfYBp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Mar_2011_10_32_18_+1100_Os3_oUDzLFVHfYBp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 14 Mar 2011 16:19:19 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/mtd/mtd_blkdevs.c: In function 'mtd_blktrans_cease_background':
> drivers/mtd/mtd_blkdevs.c:127: error: implicit declaration of function 'e=
lv_queue_empty'
>=20
> Caused by commit 7eaceaccab5f ("block: remove per-queue plugging")
> interacting with commit c7519dbf6f4b ("mtd_blkdevs: Add background
> processing support") from the mtd tree.
>=20
> I have no idea how to fix this up, so I have reverted the above commit
> from them mtd tree (along with commits a32159024620 "mtd: Add mtdswap
> block driver" and 89d8d32060de "mtd: fix printf format warnings, mostly
> lack of %zd for size_t, in mtdswap" that depend on it).
>=20
> Jens, maybe you could advise the mtd guys.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Mar_2011_10_32_18_+1100_Os3_oUDzLFVHfYBp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgUiCAAoJEDMEi1NhKgbsp4gH/2kLO/EC5qnGOqhc5tz6/BDA
4+kThupzkuiy9POijIW+3/UGBaHMqU0hlTQ6y/gILLp0EjYVTnV35hRygAX3wyhu
+Yi/cKhfh38nOC6E4BxdQ8U1Vhm2ta+OeRmwtNiPqW4xiiryrQnomrqOgVY+1aXV
8sw8lHuciIYgFVT22M+khS6msoZlXQILEKiEB28T6c2FiQX6fr53HqbQyzyLorui
WdgBDWimUPfRIHuYYoq07So4Q5fk7HrL6j7P1X+TuGpcwPtbevXNexJXOVFnrFmT
fiZN0L3wOU57Pom9YbCFiM9OObSo//umye3eAmwNacdztQO9rFF/FgF6uxCaDac=
=jcLF
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Mar_2011_10_32_18_+1100_Os3_oUDzLFVHfYBp--
