Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2FKJOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:14:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39391 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2FKJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:14:11 -0400
Date: Mon, 11 Jun 2012 17:13:50 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20120611091349.GE11439@opensource.wolfsonmicro.com>
References: <1339400131-28980-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Content-Disposition: inline
In-Reply-To: <1339400131-28980-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 04:35:31PM +0900, Jonghwa Lee wrote:

> +static int max77686_clk_enable(struct clk_hw *hw)

> +static void max77686_clk_disable(struct clk_hw *hw)

These need to be prepare() and unprepare() since these operations are
atomic.

> +{
> +	struct max77686_clk *max77686 = NULL;

The assignments here are redundant since you assign to the variable
immadiately.

> +	for ( i = 0; i < MAX77686_CLKS_NUM; i++) {

Coding style with ( i.

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1bbEAAoJEBus8iNuMP3djKEP/048EorekWZsJ6mO+fulLNBN
bTwESUu9/naEGckKE5CFdYYV7BG7Ynxh45nLTW+D7YXTKajtAYSbBlGp9iFKEIxu
FUWAy4NPNs3Gmwf1lQzLbdldr7mC+ghX4xpYJF6xfHDhs6jfiexd3x6GqTHTlWbz
7RXm1mCKDvh5Fs0G4+JaOLh2gwP3tnuHeIErH6SluCTXm3kznpkt6Piy459OgHyi
4pVfv3RJYbYVFCJV0ZqrCyab30VrKF5LWTgTyT68nKljfDc3PVPRN22Xy5JKFsBz
xfPVIRFzK7Av5UMlimm1EkwFNHNtWT98UJFNfi2ElbHHKjCs39jGzD5sj1T8edbR
90v2KdT9G2Gtf9loI0g6Y+4pxDE+1/n2gyYXN0GHLv0uxGFL7A0f6B50KQq/MsJn
NlJ/rQae2O2Kv0BT6XKsRm7yWOCJNblcJZHMoeia+TzUuMuYNBkBIRJ9gZc8aLrI
JFVnfjAhyOkTUzVIHt6LJGsuo/5xe6fijSo8wrZRpiyLsTwWIodXt/k7iqbv2EoE
XXmQ2fIXgCFaTJPiraWoKVEEzWwVusP0G5omnKciLGQLNY2ne1rds6VnMkFiaqfC
Cy1IbkYoaxWG1lRaI959w7iRrFo8BYF1zWSjY3MMVRNZieSgHzkBxdUoRADJt5wB
cZOSnxHELnJ8K7A529Mn
=wxCQ
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
