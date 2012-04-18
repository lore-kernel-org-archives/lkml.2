Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2DRQ46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:56:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35272 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab2DRQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:56:57 -0400
Date: Wed, 18 Apr 2012 17:56:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Roland Stigge <stigge@antcom.de>,
        devel@driverdev.osuosl.org, srinivas.bakki@nxp.com,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, marek.vasut@gmail.com, arm@kernel.org,
        linux-input@vger.kernel.org, axel.lin@gmail.com,
        dmitry.torokhov@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/8] Second patchset for LPC32xx device tree conversion
Message-ID: <20120418165650.GD3099@opensource.wolfsonmicro.com>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <201204180806.16848.arnd@arndb.de>
 <20120418093604.GL6498@mwanda>
 <201204181100.40123.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <201204181100.40123.arnd@arndb.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2012 at 11:00:39AM +0000, Arnd Bergmann wrote:

> 1. develop on -rc
> 2. merge with latest -next, test and make sure it works there
> 3. submit for review against -rc
> 4. have patches included in -next once reviewed, but based on -rc
> 5. when merge window opens, have patches sent for upstream inclusion

Steps 3 and 4 should be to submit against whatever branch is appropriate
for the subsystem and driver - if people follow this process they're
going to get bounced back by a fair proportion of maintainers, -rc isn't
universally what people are looking for so people should be aware that
they need to pay attention here. =20

Generally I'd say the development version is a safer bet than -rc for
most subsystems.

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjvJLAAoJEBus8iNuMP3d82kP/3+7MODQeuhg0EvXB9a6qZun
KLFE8W1nBcva8Y5Zum80CWldALRvrkJfuW6dtzeFm1wBdLm9j2J18csBOe1ITFn1
ZWIcb1vpz58MjFUoVfVGHchK5o+KGvZzDDef5PHv+mWIlc4Sv8fIbXFphG7XlVBP
AFFmmVue+ha+YTV1/yQdWwq/mhJB4kg4ypXNDt3QB/qZIc5kLzPwpJwnAHbucPXJ
/xGvZ/Df2hJMDw8jMGujTIp23Xtjl8Bd+zbNIGkxhDUBCbLW6GBVButE9LsNP9db
s0VWjOtoSoSlz25MvqBTw01X6zld5cjPgJvgUn64BHF3noaNdaeqOP2cUThKSRvY
GVr71jX1CSrOG2sjVonOMrSYEKmJJeYzD2lQIopLYC27JiWlxyxq2zvmMKWyYJdJ
/GQKe2IdyIOmign2o7Gtt2QhhjZf0Fqx8z7/f5VIOFwxeTwtmLeyvfWrflMMIZ77
7JdEisuWbtALQkhUeO0lg32gSyMG9dwcUzKMsg7Mnh4ejyrh3xZ79C+PRd7ijvJa
FhcOi0EIlEPgQLshEzRh7b/mZfL6rtBbH4FmAWp+RyTNfpGiyI3GHhve/Nk3xe+V
ADH9+YE5THd/qyhL24SngidzzJXTOWXtPMKRzFhPJz/yqNo2tUEBwvpBcZaoZ75v
SKlQT2MLqZJy70WWuyEb
=rx+r
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
