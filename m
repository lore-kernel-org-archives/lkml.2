Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3AHLSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:18:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58849 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777Ab3AHLSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:18:09 -0500
Date: Tue, 8 Jan 2013 11:18:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: max8998: Return enough delay time for
 max8998_set_voltage_buck_time_sel
Message-ID: <20130108111805.GR4544@opensource.wolfsonmicro.com>
References: <1356685743.27172.2.camel@phoenix>
 <1356686098.27172.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9lPOKfY2vCV97ybw"
Content-Disposition: inline
In-Reply-To: <1356686098.27172.6.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9lPOKfY2vCV97ybw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 28, 2012 at 05:14:58PM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP to prevent truncation by integer division issue.
> This ensures we return enough delay time.

This bit is OK.

> Since the delay is required only if the voltage is increasing,
> and we know both old_selector and new_selector.
> We can check it earlier, for linear mapping, by simply compare
> new_selector with old_selector.

This is generally a reasonable assumption but it's not a bug fix, it's
an optimisation, and we should be doing it in core code not in a
specific driver.

--9lPOKfY2vCV97ybw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7ABkAAoJELSic+t+oim94O8QAIdw9dtFiNIFYsjstg/b2rQB
FDr7bKTApmLxK2kIKuXMVHxLY1PkZmfUe78PiL7dFpr4RmuIktO4Pev0kTGqesgZ
6zQFhPKqZ38hQpH25Y7CQU4Va9nldDWdcWKQceig5L5CW1hC7QoF09b24JrzF0xQ
COfvUJ18ZMrPMFfcXng8ojxcwZq/IP+bIkTdQyCCNkxwURBTJPHvXarlKJbSRCcv
BwciWZwKzIcgjwhfv4CYUwdJ3Rp9anLRVCWosWmCfuwVjq+RRKn9MkdjTyJeAYk8
4d6OoqLHJBtAkk5Jo2cGM3+xbyvUvx0mtOtF9CasjyWRKU9Qzb8LS19JZvDXR7yP
nQswasQmNvjW5H/UMUqZ8FY+7fvM7td9NYPfGczseKwftbG9kCo9pBL8OJ9Lpbj/
Z7bGgzlyjtu5OyAQjBfSglH0GuI2Bo5UN9TcdMxqDPydTMgNWbKzkTW5Ls4KlLpA
fqerHnVMHowUp6anJtIuToztJEA4PlEB7ABwbb4xK6ygW/0VcvfojRQ664Qc9+7M
/rgfvh9CD2U9IhE1nNIU32Qvnd8Az0rDNeGDMOnqtaZClTAuwzID284b0giUzyc9
dz5d/KbDyZWto9+cARM5u46UcwJpqr6EsyrQsF2a2hsgrCA9WqNAnfpnWFuzSekg
w4AiFObR/8xpTMvSRnII
=AnjW
-----END PGP SIGNATURE-----

--9lPOKfY2vCV97ybw--
