Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2GENDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:03:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48240 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab2GENDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:03:09 -0400
Date: Thu, 5 Jul 2012 14:03:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705130306.GI4111@opensource.wolfsonmicro.com>
References: <20120703142123.GQ29030@opensource.wolfsonmicro.com>
 <4FF54406.3000307@linaro.org>
 <20120705094541.GK4111@opensource.wolfsonmicro.com>
 <4FF57EA9.7060107@linaro.org>
 <20120705120600.GT4111@opensource.wolfsonmicro.com>
 <4FF58571.2090807@linaro.org>
 <20120705122947.GY4111@opensource.wolfsonmicro.com>
 <4FF58B68.5000703@linaro.org>
 <20120705124549.GD4111@opensource.wolfsonmicro.com>
 <4FF58ED6.40106@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+MycPccvPlP5/X+"
Content-Disposition: inline
In-Reply-To: <4FF58ED6.40106@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D+MycPccvPlP5/X+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 01:55:50PM +0100, Lee Jones wrote:
> On 05/07/12 13:45, Mark Brown wrote:

> >Right, so what I'm saying is that what I'd expect unless there's
> >something unusual going on is that you wouldn't be doing the separate
> >registration of the AB8500 here and would instead be passing the
> >platform data for the AB8500 through in the same way you pass the DT
> >data through.

> Then were would you register it, if not here?

Same place as for DT.

--D+MycPccvPlP5/X+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9ZCBAAoJEBus8iNuMP3dXaMP+gLu2HNmjCDK/aKfdx/Z/2g4
0znJ/UBBrSgg9m6xztT8ZeTYGZ96VY97cdI86ulTy46L7fKj9D8lx2EjlkhaLRzw
/Do9D0zHTdfNP9jDRWWXI7QGQxpNJAOJshURzisAQFXhZHYtwJWVvHMvPKpPsSUo
3VHJSdC+5MfvISuu8nCWkEqaJ3JSg0IXAGPoRkKOzulbTRdRB3z2royZLXTbvctS
4yu7XneqDV7D5rzw9X4R32sZHHKjeGKMjFpS2Nz7tKHlSGqZ855V0VIbUApADOWE
7rVo7NTB4tL1wbEExopAbshpmxgzNfYN+ByEmo5HBsbOvsMkrxe4dYHvU83Iqv0E
aUTvaOZ70iHHQXI/5X8Fos4+suuZKzUTBPJRUBg/crJa+2ufJN6r3V0atVz4UwYf
hzEXYwwe/tp8mFpF6V7BqPY9inC+4BN2C4q/ZM3eT/0HRrn9L8sTIIImMj8GZbk9
19VrhCNG++6lY09awV8s61tfBvaBtsCYqoRzCC/BGA+/dL3g7xQ0RjxBEXPkqWSh
80QZzaGRb4bVKhDnhbxtcI77Pu5UDRQ8Tvl+6ZhPUH1YCHZAl9JudlopXBYTmGEI
bVst3vcmaGfNvKSZr/pT66igwiSGDK3DjNVjXnSRvUnCRI55f+SnDvmBvDYdaLsF
GcjuZaaQNxaCbpXbrYwu
=4v5v
-----END PGP SIGNATURE-----

--D+MycPccvPlP5/X+--
