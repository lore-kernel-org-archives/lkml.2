Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2KPURA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:17:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2KPUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:16:59 -0500
Date: Fri, 16 Nov 2012 21:16:55 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH 2/3] pwm: lpc32xx - Properly disable the clock on device
 remove
Message-ID: <20121116201655.GA24790@avionic-0098.mockup.avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
 <1352894295-14339-3-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <1352894295-14339-3-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ynwg4gOfyUw+lGhy5MYtTofa7fN5AhhREBlX7t61C61
 NBmmgT71RBvRStlM6z8qG3fTf9qhbHdRLqtI9bWaRY7zjVf7Wy
 fBctDSCfRGieQkN8dObJ8KWwoS7b4/VL9HNoDCqzdwJbgAH3JY
 tR926gkxSaeF4XvUkoLs8K6QlyLOvgy7fe8rybIWNQ61WRE5Pn
 CrDfx3RMuat0zmskZ2IIpdh9ldYG628bnS89LMKg96ajxGti2n
 N0U520ORsWht6JL9Ni8yQ8Iz3hLYy4Az36FHiUtJBe9LGIObSc
 x/eKBlkhvOFnbjZH0sfsQErLNzzVqmKLOfiLafibpq/BOYW0sw
 T7BR6XQM5dq7TVFPzcUaxacGRkePJCBj5t6syJ/yv9uHsiK04p
 9MkF/SU7o7iiHTOQuyNVhCoujJBrFZuGhCAs0TU8kRmVYUyo9T
 1Nu1b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 12:58:14PM +0100, Alban Bedel wrote:
[...]
>  static int __devexit lpc32xx_pwm_remove(struct platform_device *pdev)
>  {
>  	struct lpc32xx_pwm_chip *lpc32xx = platform_get_drvdata(pdev);
> +	int i;

This should rather be unsigned int since pwm_chip.npwm is unsigned as
well.

> +
> +	for (i = 0 ; i < lpc32xx->chip.npwm ; i += 1)

No space before ';' and "i++" please.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpp83AAoJEN0jrNd/PrOhQUEP/1duOw1H8KKgrEYzXxXMuoUC
wr62vqjJMGvZvPvhMdsf4IQOZX4iHI4si8vck8V1XTFW5VlMFUQ5lsgW2l6KdTuk
6SB+GIDH640kZINsphxx7OPEE0S33/MfnlLLdSk1GD09HRdbGH8DAuKMLvgjzxFV
70A9hycdbtx3bTkIRmlfyE+7SBTlAjYr4WA/bRWPFejYljTVnBD5/y1yDr/duJLk
pgK3ikAHE5xFFNGFrG8WM0Vnh8iUfzca2+PxMpmqJB1VDL9dUdJCV5bmz2GLf6KK
2EnJ+xG5XmJB9DKnmKDRxfkAszwpwj91skDloyNIJ/xYcDfuN+wh3Ut7pbUhGdEM
Zt7kkHPOELzWJprKV51PB8D7TuWzyqndfYdV3VqOBusFv7NGOWp537v2Ya/eEBAa
0INF8ndou0zGNHWOnSwqxLVh8nsXDGmWnLOyI+QxawLHLeo8xjW6h1eDc9oOyaU1
5FkfOlBCrgvgs+I3z7hqojZWJ8lRNL0TFUbcKX7efTHTHiTWh95Y1sPESG+iQDf1
D4+pBjMix/n4RNaBw+y986ljiQEDjzb4L2lhatsd36Y9bd7kYkhx8WbE3GLTQ0Vc
qSma6VRvB1STs8WGsBRPVIATa9w3Y5juL73U69GyyWX4nAEchnXnVvmE8WSZsIww
qmbP00M3GLlTYfdDiVZ+
=jozb
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
