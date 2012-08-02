Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2HBHfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:35:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2HBHff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:35:35 -0400
Date: Thu, 2 Aug 2012 09:35:30 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] pwm: Add missing static storage class specifiers in
 core.c file
Message-ID: <20120802073530.GA7143@avionic-0098.adnet.avionic-design.de>
References: <1343890962-25467-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1343890962-25467-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:auNAv8tG4mFNgYT+rCiCYUFN5bLrk0QYlH1YL+h9X4r
 nwDBD3USmTjT7c07jqBCyEkHv8jIBcFVn/evoJ1dWsNXdDuqsq
 3LGvTGCRvqeYQy9Mi+g+oCe+34uSP45sYxBrrc16mbBGgoGZF4
 3zd+Ee4SyETKitNyk8SNxgCs2LDNe2SWSvOSI3iEfOSxndFnZQ
 Aw/SnQ59uBimvjNQR93RU15Fhg7PWgsD1CUs7whyEod2EL5mxo
 tAP34LPjw8tVt9g5YAkqGxKSXmRJFe456Br6gLy8/WCjQp78Zj
 /NGt//hPac0x/LRNEuJBaRCdJqBguOU9DW4ePRGeB9X7Obnaej
 87pTrpJ/yn4iCky5Pjgv5pKOCcY9Ti9nGgzEVTHpzNCCrK6+uj
 zurBrZF+/jy41SwP9QGCEnfx4HLvTlXP+A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2012 at 12:32:42PM +0530, Sachin Kamat wrote:
> Fixes the following sparse warnings:
> drivers/pwm/core.c:152:6: warning:
> symbol 'of_pwmchip_add' was not declared. Should it be static?
> drivers/pwm/core.c:165:6: warning:
> symbol 'of_pwmchip_remove' was not declared. Should it be static?
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied, thanks.

Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGi3CAAoJEN0jrNd/PrOhfDoP/iv1YBrGZpSjmJz/M+nLvX7e
n2CZ1U9K5+gN1RJUfjSx9p1h4j5fJD9Zv6+Py4c6+Osz3j/3SyfKWBn+DBsc6pdh
QpL2TUhuw+Q5rLmyFbAKYsAeMMd8sgKckLjbC5Hl94GdzL2/5ta02CdFWRJA3YbD
N2Kj5YYdQQsAV23YDkl6I29Re6eGrl2xHoQCt1OFPOOPoit/ev9gsLzp0JD8Uc34
V4YeF36VQvOXgv371rA1jqz32TCvNZ+B9tGjWf8m4q72SSz/h0Mgx6eThjUFiUqq
ozEVKWdsIolRN8PZculQzH63iab5WafGZ9Gng+VT0cG45umm+pugTy+OueLbRLwG
Shq4Rvxo/Ff3YAFcvpjJmtNk6BZ+NIsEPS9VbqRHWmK4eczeEWuq8RoTfGEUFovf
AYGJT1VSWY/VYrqPEkWCZb+85Zu839daJtrIhKUci0nw1BERA+npSOxybHsS9sVW
EkQQUCMgsGhLFyWI3sr15r7dRj4kEm3sF7gv4zT9NQgrIqZ+8sjv2KrOJtgssORL
efJZ6mwKueM3Q4HCv7QmZELgUXd8o162OIk/cni0etd95i6dzcROzkXLcqdEOCPi
3Ua1OkWZoX1AWZ4tE0uOzh3ffky/fWYAreW1KXhmNUR4pm9Vrh+uSzSwsqiWdF3z
N8bnCXS2DgSt4HjMVKz3
=nwgt
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
