Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2FMRpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:45:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50327 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab2FMRpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:45:23 -0400
Date: Wed, 13 Jun 2012 18:45:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: Re: [PATCH 4/5] regulator: Replace set_voltage with set_voltage_sel
Message-ID: <20120613174521.GC7804@opensource.wolfsonmicro.com>
References: <042201cd493e$7c459f70$74d0de50$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <042201cd493e$7c459f70$74d0de50$@com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 05:28:18PM +0900, Sangbeom Kim wrote:
> To apply delay time for voltage change,
> replace s5m8767_set_voltage with s5m8767_set_voltage_sel.

Applied, thanks.

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2NGrAAoJEBus8iNuMP3dI80QAIDCa8Ml9to7AKTmxneoJ9/n
wBByxAR4ZA5nkEUEL+n3hm5G0YVA6CtBqwOTSw7hd0ziDFbo4FMis2GZ/0vUXeKn
Q/BaMAvpq8h4vQInlZv6vOPNwGeZXBhJEPI3C1PDrxG+pZn2PHkhsnVqk2JjwKfb
ZMJODtRtQ0GbL6PPWS+asexD5X/z/xkV7L0KWRZAdSmMzKiR5/cSUi4m9Gf084KA
UCVGnAbAemLYtoiidZdYKXovV3Q9NwbXddGVqPrQ+dw0X7T+bPf8pCgVgc4jX1gd
3OIAfUb8QSsuzPqVkxbEXzFHfQN5EC9a0r3fTxT+pcLINvsiSXHchk64sYAyoUay
kdgB6x1+iuXSYDixEusF6d1XA4NGVDresfi24fJYyzKt8Er7IMbJS73eb2t8LmUA
iFBA/orhle3Cq2ROalwNuVOSzPUkRf+xyRLgKR8SDQJQT5pdFMamKHQzOk0fsChs
Gl3ESZh1FryFsqlxvHndQ6aE3VCgJiP15mzs2t0mU2DyprYOvO+V12na0jxpF3p2
+4lV6F2WV1mkIZftAsSjs0i+BacmwTmw6fWp4DYSmfWGF5gXKOgumuqzL1WI0BhT
1/cGEpST4DAQ/CA3tKfSQGLQsYsSrfwdhxyqmVcOFhnobNkY9CBql6LWZMJ9Cs98
ber6l+RDuRe/wnAG7vFw
=N0Wa
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
