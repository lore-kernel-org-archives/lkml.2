Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2DXMkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:40:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59999 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab2DXMke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:40:34 -0400
Date: Tue, 24 Apr 2012 13:40:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, w.sang@pengutronix.de,
        ben-linux@fluff.org, swarren@wwwdotorg.org, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol
 mangling
Message-ID: <20120424124030.GD13747@opensource.wolfsonmicro.com>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
 <1335251976-31925-3-git-send-email-ldewangan@nvidia.com>
 <20120424105557.7ac07232@endymion.delvare>
 <4F967089.3050004@nvidia.com>
 <20120424143241.0d66fd2e@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <20120424143241.0d66fd2e@endymion.delvare>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 24, 2012 at 02:32:41PM +0200, Jean Delvare wrote:

> Please keep in mind that support for I2C_M_NOSTART at the bus driver
> level is optional. This means that device drivers are encouraged to not
> rely on it unconditionally. Originally the flag was meant to workaround

Yeah, for regmap we certainly have a fallback to kmalloc() a buffer as
needed in there already.  Like I say it's just an optimisation.

> If you want to do scatter-gather for I2C messages, I understand the
> benefit and I have no objection, and I agree that I2C_M_NOSTART lets
> you do that, but then:

> * We should allocate a new functionality flag for it.
> * We should update the documentation to reflect the two use cases.

That sounds like a good plan.  I'll try to get round to it if nobody
beats me to it.

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlp84AAoJEBus8iNuMP3dWhMP/RMauyCf8KQimGtVYPRtZ1nJ
WSig+GyXQX+AQ/XB1glFzyasV9byJJCrHTZRf314y7tfVnggcEq0Ar+McfFofmCW
ZV1d/9U2MlVRysASiBUgiG2BRaWY20nfXvFHw2zKeByKjYBruxX1gyWGdvVJoQkF
lkdQ8CBG60lGj15YYkJRit6x19bghT2VjKiGWKnNj1sEpaFaeD9XK9PBvqmkEyJ1
8vxsS/2IFsUYSZ6/dXkMx7/ka1NBCZDeMY7vvReG6MnG27BQJpDezx/nvmKV+I7r
Q9z18wMTCFw+DGN3Akqxn90eh0R6sMCheJmJ6mtaWWg3LjVFbol0Pvlk7iQCX35z
hBzsXM3jeeRbvzbfE3+F2b0GAJE98C5tYHnqya7NIjfOTx3tuYsOx48ApMbDr7iP
Iml8MpmiGAC1+Jj4BI6glEDTXdXCX8UJH7Zp5Xc+KFpQw+ZgHLLZoNkWHFZX/Slm
/9dFCWSPnpek4yoItHlFpc5ah5gdIp8aZommb1Uv8tAh/5VV6d3jhfFB3Sb5t8Zm
CzgTQsIvvOD0fwjChztBddyLx9gsmBZo8u+GTryTTzw2l9sNMurS06s6YD7Htg2T
dtaXx6oQ9ZvpX7cttoDIcWgmgh5z/v3Zkt/upDvX3eVW9vl/DaRvkjGQcS6zo2qm
12ztE4SHX9gHBLu7g59r
=3dCN
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
