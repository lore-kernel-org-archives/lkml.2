Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2GCKkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:40:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47624 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab2GCKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:40:41 -0400
Date: Tue, 3 Jul 2012 10:34:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: enable module build for lp872x driver
Message-ID: <20120703093419.GB29030@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FCCCF@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FCCCF@DQHE02.ent.ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 01:18:53AM +0000, Kim, Milo wrote:
>=20
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

No, this won't build.  As we went through when we had to fix that only
the other week...

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8ryVAAoJEBus8iNuMP3dcAYP/jC3B2PS8ZFBnsh/n1a2vw/C
JFAWbvoJaHHXWBX2cCeVRwuG/u/hZ9ZebZuAt/rG4isD2qLRbiEDRPZwB8Q9BGpT
ZiF1CnUJN0iABAplLaOYXl8g8VVBavweUA8hIchDRF4gDC3Sul2BgmPeD5CtWDDa
ZsfbybC6HZcYQRpx3tFhIEr7MS+8SjTRmB/Ft7Dv08U6YaciBl//YnCFoj+/qzz0
0PslqCG0syLAE2KnGA4uKSsnIlDsYA5SphfCl0wYj7VyxAPMXD682M3KL3DuP1Uf
WCBIjcValaWEgPB9duUQ/neklYGf2ABFd3QAhp4dq4I3/odbRlsQB5Dnp0EMxyAB
khdDG2QY7FvQJf0nU3g85mVWAskTi6IPHFCyf++RQwNl9yJ3OEnbB4haN8iUnLh6
8yadwnV7JOC+77vkaLeDCCfpp0ByTqx5ESxjjxQpIq1jB/6EUJg6eNfTGrQumaFF
IcIcWV5HpUnqH0qGUrRiGgU2Fl4lTBEdrR+hqojRj265O78TW8m6b+wEbD/kIDMu
qc5Rfq8HnlhqRb9UpR22ng4KgxfVmfNjgAVzdSBY/ASyY7a6qpiu6N5Q4Wn9Tuyz
evPjNEGkwQR1QC5W/+Z0vyLGIaeImKXtzYMzFxmcEQdQPLO1pMG/gGLYjoMnsdvS
pScenyNqZ4oHsBLSWbSx
=Y7Wi
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
