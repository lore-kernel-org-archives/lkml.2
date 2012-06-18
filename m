Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2FRMMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:12:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50022 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab2FRMMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:12:36 -0400
Date: Mon, 18 Jun 2012 13:12:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, "'Liam Girdwood'" <lrg@ti.com>,
        linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: Re: [PATCH 2/7] regulator: s5m8767: Modify header file and Kconfig
Message-ID: <20120618121234.GK3974@opensource.wolfsonmicro.com>
References: <067401cd4d45$898d8d90$9ca8a8b0$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RVlUGXxwBj5SDcM9"
Content-Disposition: inline
In-Reply-To: <067401cd4d45$898d8d90$9ca8a8b0$@com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RVlUGXxwBj5SDcM9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 08:28:51PM +0900, Sangbeom Kim wrote:
> As name of samsung pmic mfd driver is changed,
> Modify s5m8767 regulator header and Kconfig.

This needs to be squashed into the previous rename to avoid build
breaks.

--RVlUGXxwBj5SDcM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3xsRAAoJEBus8iNuMP3d5dkP/ixGFQnCt/XtVoCQUg5ahPNP
qMDHBQd1xkQ8KB2EqJaLnJGMnUxgtMZJHjNEApw4H9UGNcuaLT5h4k0UkIe8lFXJ
br8Zl2oYc+z/ZP8J9nNzRr6mMIHDtfqxi7er77Ra+Y00DcWTeOVVlVA6fHpC7x8J
C2GpWRYr4VWbfeOocI9QZmtY+n4DAPeopDH2btmyoJBz+0gqy1GoZFcnDEST8SXr
tO+SfZDvtTmgWjaRvIscKVeVS/KBQf94f/yXqxnjm9ZGLstcZwpiiJgUdsW/IYuD
5bLH1UvSlsjRC8n7nYI3j7ITnXlGKd9Fx18mu0LSJwS37vwAYLR30dfe5etk0Rea
O30qPewDVce70dSQft5F1xRG7YOraymDzWi0M9rLATfPMFYDREoBKveSHSvpoxFE
3wj2ucfDv4oPXvT3IMBNFGSJPUQgp1MAQuKlTBT4O+TFXLrknFtU0mksGXXgfcWn
0FNpBBAjeI0AvdnKCb5T94rchoy37WMKDb5qE6HhnZddHMZnRtNz5ngr+f0YIHEm
ianeCI79atP9dON4ntybnxZBU/SUehvlw3/fvb40hkG8ZABHchLEgLw1t5hpdUyt
eAAH/KzCj5WcuxnfhqBLtBwCxTkZ5HS8S93x9pslKSQeeAxZ1oIKsPKlYxExJ/UZ
W0/vy5VbjUn9jb1Begyr
=jiFU
-----END PGP SIGNATURE-----

--RVlUGXxwBj5SDcM9--
