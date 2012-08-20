Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2HTQ3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:29:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33091 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723Ab2HTQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:29:25 -0400
Date: Mon, 20 Aug 2012 17:29:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120820162923.GF26991@opensource.wolfsonmicro.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
 <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <20120820125531.GA20242@gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 20, 2012 at 01:55:32PM +0100, Lee Jones wrote:

> Right, that was the initial intention. It would be a trivial semantic
> change if drivers without DT support wished to use the functionality
> though. However, the only examples I found of a non-DT enabled driver
> that could make good use of it in order to strip out some cruft would
> be the Arizona and one of the Samsung drivers, and they each have

All of the regmap devices could use this.

> their own hand-rolled methods of hwirq -> virq conversion now, so any
> change to support them would result in multiple invocations of
> irq_create_mapping which would likely cause breakage.

Multiple calls to irq_create_mapping() are totally fine.

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMmXaAAoJEFJkBDiqVpZ4TlcP/iUX+uAvu/A/mFneHzl0Sjen
Sf8SwoYbWpDwHCsSyDmK8XogbqJJTs6EL5GTkEg+l2obJhzf3o4rGRq9mIC123J4
/8ALZ7anQSOrbcNen5mCgI99nmdWFOPl3dnVZ66EoOMxppa3lMq701Z84KZ7ov0i
5gEPoAWN3+5Xh6RcmY30ONCbM5aVU4+QFRL/ONY2rV+lWVGJq3C9aRRpVSMbMhHC
ORtxM6LHuhGCGPFECLNrBGqKQe0ZxOIXdf2qiNpUtOuqLFMSDDHaqyr6TO/HmxAV
BYX62845luaWDA0BGhtAmgEQegM8LiaOz+Lvm3mi1DyodC1x5WXXB/nmSk0L8Cc8
3/SXlndJNP9QPpLrrPBJoDq3F/M0WPk3tCa8r6IfyEuqTR4wFXu1MR6Frl038Hwr
Czx9+U/cpnZVJOFmPxITuSVdT9a6RyLGB9au3L6A21Gyqb9rtx5W1spB+Rs2EYcF
2dExXf0wTV//TXkmgzxzInvHY0UrPSOnsx+T/0JFbzB/4O7Gx22PanLpPrza/ED1
6PKiOw60oijaVMHh637BJCm50KY1rKi8/NIZ9o+x07NhPNhYiPEggdXlCSMpSyel
GHIP0FklyoD+XlGTU4knTJRZQFzhQQL6Y0jxTh47EaJuI6lF4rLxEtS4sOoem5iL
yq901I0GL4Vz34H7haTu
=RY7n
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
