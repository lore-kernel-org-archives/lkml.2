Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab2BKNRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:17:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39411 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab2BKNRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:17:22 -0500
Date: Sat, 11 Feb 2012 13:17:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, eric.miao@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v4 2/2] Regulator: Add Anatop regulator driver
Message-ID: <20120211131718.GA31887@opensource.wolfsonmicro.com>
References: <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
 <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
 <1328734286-30091-2-git-send-email-paul.liu@linaro.org>
 <20120211063637.GC2198@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20120211063637.GC2198@r65073-Latitude-D630>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 10:36:38PM -0800, Shawn Guo wrote:
> On Thu, Feb 09, 2012 at 04:51:26AM +0800, Ying-Chun Liu (PaulLiu) wrote:

> > +	rval = of_get_property(np, "min-voltage", NULL);
> > +	if (rval)
> > +		sreg->rdata->min_voltage = be32_to_cpu(*rval);
> > +	rval = of_get_property(np, "max-voltage", NULL);
> > +	if (rval)
> > +		sreg->rdata->max_voltage = be32_to_cpu(*rval);

> We need a sensible binding document to understand those.  But at least,
> shouldn't min-voltage and max-voltage be retrieved as the common
> regulator binding documented in
> Documentation/devicetree/bindings/regulator/regulator.txt?

Normally this would be a bad idea as the set of voltages that can safely
be used on a given board might differ from those which are supported by
the device.  However in this case you might be OK as this is all
internal to the SoC and so presumably won't vary from board to board.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNmpXAAoJEBus8iNuMP3dXuQQAJ2XQ05dvcWJteVKkB6e2xC3
pJGjYxPQR3MQi0Avn5m8hE7RPqDnQTkeTmHjaMdezwzkZHM0Aypr67cW7LUKLHbC
8jRdKxeKHwrG9I9IoRpKF0D/osLjFWTgy8+Vw2RlA85sGmDZdDCjoXbl2g6midZq
1vTu2A17yzejTWR7ZEEj/HJdM/ETb0k6adg6aXGQpnuhBaqteOeeIjmxSy5tpkCv
By+g//vSFMSWbMzgKBVFl5d+9q/UNx1dgmYLLNTrk7FWVeGU7Rj8x4g5ZPSWXzID
a4sJ1lpQsuv3Ebc0anuFUDQIz1Huen+6WK9Ziy18yfdmfkbGsGjBEDqXBmwbvVt7
/SgSEy/wj8zdu85lKxHhN3kOFF0x5FShTYFss1b040cGUiS9p/ihMge2aeC6mufJ
7qZQ/hU9bjgK22JHLvieTCzQgAx7TXRp4BeOnjmo3gTqH0HhQuJ8jK3H5Buv9E7M
a2EMOZfCjsIR+BVpFGM9q0NlkCL5rtxxQyceX9KfrHcxW24gLm9cHebb5ZcaUljj
HbMye9ZIjobK0oMx1LLNO5h/gEJ5g5M2ZWH8ExlW1REFaw3A3lJK/x1Se9hVymwL
DW87+i96VqMaR5Rim/Qj/9X0YVcgHNgJWZlEylhfvOHf+MiYOO12PDu8wx2kOzEc
Vffl4TCmo2RJiXTtBQ+y
=vjNY
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
