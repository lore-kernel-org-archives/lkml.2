Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2CZReg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:34:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57930 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933106Ab2CZRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:34:34 -0400
Date: Mon, 26 Mar 2012 18:34:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Add MAX8997_VOLTAGE_REGULATOR and
 MAX8997_CURRENT_REGULATOR macros
Message-ID: <20120326173433.GF3789@opensource.wolfsonmicro.com>
References: <1331621638.3932.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="twz1s1Hj1O0rHoT0"
Content-Disposition: inline
In-Reply-To: <1331621638.3932.1.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--twz1s1Hj1O0rHoT0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 02:53:58PM +0800, Axel Lin wrote:
> MAX8997_VOLTAGE_REGULATOR macro has _name and _ops parameters so we can use it
> for all regulators with REGULATOR_VOLTAGE type.
> The MAX8997_VOLTAGE_REGULATOR now replaces regulator_desc_ldo and
> regulator_desc_buck macros.

Applied, thanks.

--twz1s1Hj1O0rHoT0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKiiAAoJEBus8iNuMP3dHLMP/0SvG19AONEbhVDsZ/v3gQlk
7E3PJANwrAkeaDs+aEpN/WMP7x2hpTmHt1dSsANdR4F+CuAlWZTKMHgOH3eX0HC2
D8ZmiAYswMhJgAcoc/HKJOT9jsSw0hHGuL6/VBdk5Dp0US+869hihCuW+fhNRTof
J/6kUByoZbcSZ6zS/50W6dd/AGnA8s9cVtzbYAF1u/4Dmxfk0QHiEEX22uj97Xfa
g5LF+wCjZ7McOeaabnI7ikukEk9S36J4vDJdbD3ab6W8Xepi9bE3saQrVaQKHGEC
JbKttVtH9IoQItz0PNd1w/cPj6YURS81DGG3jqmqAnI0f5EE4KKcniionw3bm0VD
xE4U1iTTtm3FvqOdJzILdDuevg5HcaRGJ4xGRZc8JG61rqSCr/n0rxcFRSZlCzmx
a2hCNhQE+8fGapvMRalppApGf5Zqny+ln4mBupYVc2SCh1NqTqgvbE0+JCQkR7vp
sCAZJK9plXyJYx5xgH4Vgw/WcMAoJLY/b0czyrpm5emYrapvbrvub+y8Lq5BHpiW
9p1cBvIjFBdjWy7okvWmU6oKqWlaUlo2o0vdddEUfj+LT4iSBZcw0Je+Ad0XD9sk
WB65ArdGnXHT5/claUMYnb8ZPU4w27P8g/9uFohdlqeIdnxrz9j/w0M/eFX4FgYT
ptKCpm+pVyb7khlFqiTL
=gAtd
-----END PGP SIGNATURE-----

--twz1s1Hj1O0rHoT0--
