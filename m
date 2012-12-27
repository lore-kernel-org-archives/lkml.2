Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2L0RfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 12:35:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39459 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2L0RfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 12:35:10 -0500
Date: Thu, 27 Dec 2012 17:35:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: max8997: Remove set_voltage_time_sel
 setting for max8997_ldo_ops
Message-ID: <20121227173508.GJ5005@opensource.wolfsonmicro.com>
References: <1356510519.16892.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j/HO4hzKTNbM1mOX"
Content-Disposition: inline
In-Reply-To: <1356510519.16892.3.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j/HO4hzKTNbM1mOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 26, 2012 at 04:28:39PM +0800, Axel Lin wrote:
> max8997_set_voltage_ldobuck_time_sel() returns 0 for all LDOs.
> Thus remove set_voltage_time_sel setting for max8997_ldo_ops.

Applied both, thanks.

--j/HO4hzKTNbM1mOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3IbAAAoJELSic+t+oim94RYP/Rq3VHwEhOFRozHoye7lxp/S
MrHktua8aeoNAAHFOTThIl2DEeJI5VoPl5CnXJM6Hnm9kMXMpHymJY9Eu4Czh1/b
2av/BjPZdbWvvvQ3yvz/DGoqYzdb/PtzZ+aDh8BNdWZruOhQP/tRV8bEEg3zgCo+
kUFTuNJJH/kgEmIjbnJ3usuy5zClgvxlLATW4dUUgTPuSE4Kp/iGijop/vuMTeRP
RF5b7GlksKyLFC57M/k9RYFnsusCf/Uh6UWA7Ueg6se94AekIhBTeMs9F0dPa5RP
u2215tHa0OBUGHK7yWXgKqiySDnmSIREIwPMGOGkmwKisaijiWAO+IaKFSSevNI+
h5JUyLGag+9lquC3iE0gi2dPZs0+gG87sNKwWvWfJmvDHCyEQcFJxrezexWJzti0
FqLU6ft7jsjSHWgIFI3PGxFCllUFsmZdiddi2CDjT24O1QjfmeGjYoypFlPSHvbr
+rET0RmlDGxAk0G85/hxwDHEiiXyq7v3Y59jJJFxjMV20rVIXyOM0nJqP9OXlIO+
Mp+mu3rTL8NKxJcpeMxuY6XQwIIGZGaqGAlKZxl0LPYQeeVr4iEMIRYgTUotNWAp
q4q6TRfw+Q7YVOPXtGgKbc11RMFXJWDetyl2YeEjmzNBKhhsSd7Pux+BHrYxFEqF
kdZMW65xvZIHlMMg4rBx
=kYpV
-----END PGP SIGNATURE-----

--j/HO4hzKTNbM1mOX--
