Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2DQO0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:26:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36088 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab2DQO0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:26:16 -0400
Date: Tue, 17 Apr 2012 15:26:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: Convert max8997 to get_voltage_sel
Message-ID: <20120417142612.GI6652@opensource.wolfsonmicro.com>
References: <1334156171.2469.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zqjkMoGlbUJ91oFe"
Content-Disposition: inline
In-Reply-To: <1334156171.2469.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zqjkMoGlbUJ91oFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 10:56:11PM +0800, Axel Lin wrote:
> Also rename get_current_limit and set_current_limit callbacks
> to max8997_get_current_limit and max8997_set_current_limit for
> better readability.

Applied both, thanks.

--zqjkMoGlbUJ91oFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjX19AAoJEBus8iNuMP3dvVwP+wZ7Rk21uJykApMMGYzOxDzF
hXMDiXaoZ769MCQNTO6vlvESyFYGPC9n9M9ls1hsJpFDJL0xUDOP6hsO70zjV/fp
vP5iLOSmh5MkjdbwdceoC8LSHAWpJ6KdtcTPGZ+WCJEaEzRJn5bqlRErGHroZt6A
Y9dLomfRO1Z6KynJgOTeFOwua0yee96m6DWOvT1rcnSP1BMn8zkPwMgk4B1gER3Q
+on0j7MwZnIziMJ/YieGvViOQ8ASTFxVlXmYAZROsK/nArz84N3gvbQDpaPd8Qq/
GgpTM8y4UJWwE/A4YjUd01x6vjCOg/BkXoG+ecuMq7PWPvuDZSzFKP43XeEZdT7K
TVwhd7ZfShv3fp+nHAOwgMJCdIK79JWGJFQJ25aZW1xK38wYwgrMrgJU5EFg7fAQ
D5AaB6YbQdF//aLA7gsxuC5HlF9gQq+R37AxGxTxbbmBgqimJiR5gMHUz4wmPuuk
KCsdDJ/Z+JhGregTNcBrGrgVUMJ4QazU5W7u724ElNjQqMgPWVmpMC3GtXWCOErS
CJ39U/c/KOv6TF1nEX1pv+zCdaOnRaykz1V6XXTigJJ5ANI64HYY5HNRA4G+HM2r
21clTNbjo5BTqC0QWw0gVkCYzqe9ky2JidkZxq9Z295T6eCwpB8k+t1V578e//5V
J4JrUicayeRzeKLzpqLd
=m/Hr
-----END PGP SIGNATURE-----

--zqjkMoGlbUJ91oFe--
