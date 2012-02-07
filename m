Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2BGNhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:37:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45901 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab2BGNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:37:17 -0500
Date: Tue, 7 Feb 2012 13:37:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/7] ASoC: twl6040: Remove dependency on twl4030 from
 Kconfig
Message-ID: <20120207133715.GO3332@opensource.wolfsonmicro.com>
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
 <1328619678-26080-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6iXXu7NwgEt9u5a7"
Content-Disposition: inline
In-Reply-To: <1328619678-26080-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6iXXu7NwgEt9u5a7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 03:01:14PM +0200, Peter Ujfalusi wrote:

> -	select SND_SOC_TWL6040 if TWL4030_CORE
> +	select SND_SOC_TWL6040

I'd expect this to be changed to an if I2C rather than no dependency at
all?

--6iXXu7NwgEt9u5a7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMSj2AAoJEBus8iNuMP3dNsYP+gKKniE5HzggVh1Kp+sKMSEk
k3uGFpFTJny85wZhb97LJR/CeokEKVNNhWvp4vWBLZv+Aa0U6qCkQMTQaQ8TiSlM
pKStLAJ9upAGG1tioU6+gdYaW8WNSQ1ovDR2C8PZPWyl9VUwKHSTplTqVlaPY0I4
AQmLgYMClPWT4uHJ68RuaYcJ7ncbAjshUbyJR6njEfxc3GatQlPAdpLsB3Xp/Qnf
82X7vFUkTqf8whHiNrRnIoKbhslBEOTqkAsv75Hb8AfVtIO0m/D68uSCfEOtc2lf
A5mJZUrDVFJTOykoRCOWj3JaAo3HKfrConnavZ1xPouYqZ0NMcLpCq3iWsDLVfmY
WvT2MAbmQXSV1e8GLkL3C5BpEAX20dXpJegXQM6la2BpcN5y66Q8KXQ/pSsw1QuA
pDZzOydZ9yPPIWJyhiT+c7hvaLN1iwRv75UiTTAXs2DoK1/rZttliZ6jhWmPROw8
s3yZhhBcLvYyfKWbmqwcFUhfrhLZpTeOhKsVQBckytLHBtTCtCJZYWpXhFkXh23h
5o89x/ZuRzTH39ydUerHtYwzT+NtqDE6muTiP1zQPlYTC2SsGFpwwCM/daa3tFbn
OFG48U/6Ip2a7N6fnW1bD7Sb6Pf5Kw8APWhYHGqCn8yyqrkJNhTpttXyidzfBFMa
W5pw/p5OmB5CghulioMR
=+ldy
-----END PGP SIGNATURE-----

--6iXXu7NwgEt9u5a7--
