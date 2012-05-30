Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2E3PLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:11:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49200 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab2E3PLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:11:23 -0400
Date: Wed, 30 May 2012 16:11:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120530151119.GN9947@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
 <20120530100302.GD9947@opensource.wolfsonmicro.com>
 <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com>
 <20120530121547.GJ9947@opensource.wolfsonmicro.com>
 <4FC63632.4030504@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrXiCraHbXeog9mY"
Content-Disposition: inline
In-Reply-To: <4FC63632.4030504@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nrXiCraHbXeog9mY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 30, 2012 at 11:01:06PM +0800, Lee Jones wrote:
> On 30/05/12 20:15, Mark Brown wrote:

> I personally think:

> 	vin-supply = <&db8500_vape_reg>;
> 	vmmc-supply = <&ab8500_ldo_aux2_reg>;

Oh, oops.  This is going to be fun when someone puts down two of the
same PMIC on a system...

--nrXiCraHbXeog9mY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxjhlAAoJEBus8iNuMP3drU4P/REeuuslpOT00wWO2wWWnbNG
JXJD4U3Ch3WcoKtotfIrLWBm8czIaCUlgr7dkL4Hik84oZUCZR4E8lms4hRW8Lkz
6tdU+TZs4ExYQShPEENr03XlbSSlf9tnu7URUrXYNrCzD5z8PwXq/XjZygsFADLZ
qFifGdOIWhfsVLfOXZkldrHCZUyua5q1mhgyBtHxnhWolxuhxHJ5rZnvSUizCwtF
hNAqoZ+y+XS4VdUlAxX1Rzl8+gRFFeSpOrlfaTv9dK6RyPkwibyEMtwxu327xf3Q
W9awCWvN+RQpZVozR6uuNGKfuCp3IcqTwCcnAbg0fDBNhLBeDbtBrSoMunDMFxoN
ofHPMYFb6170Q6ZhXIus8TVMJc+LpwGYXWxsLMjAJKT4kURI3q/p6E6PSUAD2mq8
sFUTar6sg9w3KHnMIRAXcrMhj57CI70t4C/Um/sl1rg5sHkPazkFx/pVaG2AIeQw
wM2AQtoBsgfn7w0UqAEthBi+nW6+0GsGpmo8wxe9Zv340l+W6NrQ12WXclhJivYX
ivyDwCcxvZWx7ImADaKbzJF25wAIuO7YG1/K/Ts/T7U8E6Pa4W3zenDgfIiLNw5s
1VmsRaI11Tteql16zkB2xJLe7K2lZUoAko2XhxQKFNmYixxNOwhmrVxwS7UevZ93
EGctcz5szS/SUO3JkuOU
=1mem
-----END PGP SIGNATURE-----

--nrXiCraHbXeog9mY--
