Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2CIMfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:35:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40551 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab2CIMfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:35:14 -0500
Date: Fri, 9 Mar 2012 12:35:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Rename s5m8767_convert_voltage to
 s5m8767_convert_voltage_to_sel
Message-ID: <20120309123511.GR3273@opensource.wolfsonmicro.com>
References: <1331263868.6239.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="chReQkDOePndSGWY"
Content-Disposition: inline
In-Reply-To: <1331263868.6239.6.camel@phoenix>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--chReQkDOePndSGWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 11:31:08AM +0800, Axel Lin wrote:
> This function finds the smallest voltage that falls within the specified range,
> and then returns the selector. This rename makes the intention more clear.

Applied, thanks.

--chReQkDOePndSGWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWfj3AAoJEBus8iNuMP3d8+EP/1QE9Yqsc+LroGmZV00DmpVS
9vd1Iwkdh1wmbMRHksj5Hblr87gmIBukfZl+NviUEV2I+f4/7udBpimBaZBu0BuO
uxAmAxquYlToKNEhwbCAGmW7kBX+HvPqr96hIuNTp6LPlef15sv0lUE6FsEfqjcy
lgYDwwNZGs/VdWukcx6ZRIpx7Lia5NmlIDJay+FMMIP3y12WmPF9Mlup+GNYOeF+
pIOunthfgNuuIFkO1RxruKfRyfJ6Lul1b8OkqLrhfAgByRuTusbm0IkyLfg6ESdh
pU2NOT7Yqr7/WQY/eFjJDd9ObE67Fhkx/8iI8nf2udRC8oGaLRWAvyGQwimeGbt6
x3sPhrBxuDoHUzDd7S3Z/F53/XPF/WFDsybBcsM2LvG8vF4pCCmwS2M04Y0dSuYb
DAK89CIal+v6+PeitAupVgacK551Wc0Ivlg8CNX5TZpaZV6LVG+rLT5UyzAMu+4+
pZfcybZVSxywfAznVwelnuuS/pHVFljdOxp8nEAUcyV42Iqr5r0fOfTuP7m20iUP
HqD8cJgCZF+USSAsnk75ls5XMqO1RwPusz5qhPy5EDjnRmeh21qq7CdsC3SMTojf
0VbrpWXpBIRP4rW4gaX089A2nHvBS8fA0YOpQo86KrdYORWr3sTOzXiifjvWTOWR
iVUx5t5st1mj7rBnSYXJ
=qzo6
-----END PGP SIGNATURE-----

--chReQkDOePndSGWY--
