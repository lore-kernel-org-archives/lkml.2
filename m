Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2GISph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:45:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43546 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab2GISpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:45:35 -0400
Date: Mon, 9 Jul 2012 19:45:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: max8952: Remove wrong set_suspend_disable
 callback setting
Message-ID: <20120709184530.GP3934@opensource.wolfsonmicro.com>
References: <1341573852.6611.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ep5m4srWGXPl6O+g"
Content-Disposition: inline
In-Reply-To: <1341573852.6611.3.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ep5m4srWGXPl6O+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 07:24:12PM +0800, Axel Lin wrote:
> Using the same ops for both .disable and .set_suspend_disable callbacks is
> actively broken. This patch removes .set_suspend_disable callback setting.

Applied both, thanks.

--Ep5m4srWGXPl6O+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+ybDAAoJEBus8iNuMP3ddd8P/198IyQl+pfTTc8zUWcvQ57L
2zwWJpovcEcu6DCTLGWYeCsiai9mdnlzERpFOcGat19Ad3YfWXTBLkXCHtN36J1v
/Y3Wsx9t5lRroJ7pCTDDiAuLD1py+AlZUMOD/Ob6iZOA9OiXpOOEgmmUDDRgwKw9
k5oa2IRS5uCCan2v2YZeUC85OLBJWb9atKswUPP722aHdQcMw5WHup0T73xtv6Dp
gLC94TQBNg8rZcZCsF8jlyMXatuTeokLpTS77M6BGKRSMaziuOWnfLzSeFybgizg
+GE4cN1nCPjlezvCFZBMnmjlTSw1zR0GIIFsDrF0hI7G2hiZh1CNa160DIHcfbTK
GoV7UGedifZes+6TBAsRhratU1Pysj/OEEpLQenrs+NB29TIdr4MLqXeKrzjpPb/
gmH7oSs+9V42JB3dFbjDTNLTUyyL4WVIQ06GkXVt04BZOhLh2l1LuyiioWnK2JrZ
NAMDNNnBkAJEhfhZG95lQxwkLucb8nBXMq+EJmKnW+fWKqvKpE53GxnO1hXTKRjY
yd7v1Cuxl29/PoH2KKI0XFXT8tXkARSsFb87XTbAVD3h3D090NDTJcvl1rA+t1f0
DJC+t1WrRPBoGYKgwSYEcTOKk1+noJGcnGXYS3v8gifYdy+KodqjcfD54ltAyykx
4Gbu+7lCLBhnuGJQ0+Fb
=4hKh
-----END PGP SIGNATURE-----

--Ep5m4srWGXPl6O+g--
