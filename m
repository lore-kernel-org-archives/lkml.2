Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1LLLYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:24:54 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53503 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1LLLYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:24:53 -0500
Subject: Re: [PATCH 08/10] omapfb: lcd_ams_delta: Drive control lines over
 GPIO
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
In-Reply-To: <1323634328-856-9-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
	 <1323634328-856-9-git-send-email-jkrzyszt@tis.icnet.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HrrbFEKLHQnNz2ugs0wK"
Date: Mon, 12 Dec 2011 13:24:47 +0200
Message-ID: <1323689087.3852.19.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HrrbFEKLHQnNz2ugs0wK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-12-11 at 21:12 +0100, Janusz Krzysztofik wrote:
> Don't use Amstrad Delta custom I/O functions any longer, use GPIO API
> instead.
>=20
> Depends on patch 5/10 "MTD: NAND: ams-delta: Use GPIO instead of custom
> I/O".
>=20
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
>  arch/arm/mach-omap1/board-ams-delta.c             |   10 -------
>  arch/arm/plat-omap/include/plat/board-ams-delta.h |    2 -
>  drivers/video/omap/lcd_ams_delta.c                |   27 +++++++++++++++=
-----
>  3 files changed, 20 insertions(+), 19 deletions(-)

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi


--=-HrrbFEKLHQnNz2ugs0wK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO5eR/AAoJEPo9qoy8lh71y4AP/36ymwGQfo0/xUblq852gGHK
tddm2t7IxPa246K8pshBAskSuCLlmL9lDmjj3r5NWnU4HxHxfLtoRRjfyCBS+RtV
YvKaWwHIdbx5fpiIsMiWlmuqHdZGST3RGPSqR/k/niT+PSHnk25iCIdOvCi9TM9/
b4/uKGvR0A6bC2Q1JmhWVaTt2jsYtsCbYSd/vd2EAqxd/QwU6MI/q92YxWG8k3Np
fSGSvRC3Y6eCJIwav5SF1+dX4Wnr/d1etWWJ696etdG1AU6/hxp3zHcNQd0LBqyd
THRvM05HsLmETf4dcQFy4CIS13F41gkjaR8OtqEpJ6wYrWd8ygmSdv6GdCpR4Z8/
Y5zcBcPrwI9/2MgqdoRblqGfuaYPZ6V1kdMHrZlk4Jz3UUluiTBdEQy0bBneiSqp
yGAxx6goIYcTc94NIp8hr5+DH7qmNcroMRkhgEbGaerF01+p0gwj+Xe5ER4rW8Az
nQgfTpWk3mUohTWs92XYIlrpjvWv5AnuNTfEe7yzcetIUw3y4b4wbriTzZA/a/ir
8UqKyFnduoTu2BAUOSsZrzok2/diRAvuvqQC0ByEf7yewg/uwFUyv5YhclHTUXOP
MBZwDY7U2VXEbF+lLagrAud/dsDR7OA+rfi3izWBcvJ3RI0z0i9cBTEbrxEzIUvQ
1rjc4B7YLHQ/HMw3JSfk
=ca/Q
-----END PGP SIGNATURE-----

--=-HrrbFEKLHQnNz2ugs0wK--

