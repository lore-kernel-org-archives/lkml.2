Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab2GEMlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:41:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33871 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab2GEMlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:41:44 -0400
Date: Thu, 5 Jul 2012 13:41:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH 4/6] mfd: max77686: Add device tree support.
Message-ID: <20120705124141.GB4111@opensource.wolfsonmicro.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
 <1341460705-10868-4-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PgFjNgMZ2k7V6t4+"
Content-Disposition: inline
In-Reply-To: <1341460705-10868-4-git-send-email-yadi.brar@samsung.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PgFjNgMZ2k7V6t4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 09:28:23AM +0530, Yadwinder Singh Brar wrote:

> +	regulator_name {
> +		standard regulator constraints....
> +	};
> +	refer Documentation/devicetree/bindings/regulator/regulator.txt

> +  The names of regulator should be as follow:
> +
> +	-LDOn 	:	for LDOs, where n can lie in range 1 to 26.
> +		 	example: LDO1, LDO2, LDO26.
> +	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 9.
> +			example: BUCK1, BUCK5, BUCK9.

You need to update this to use the regulator-compatible property.

--PgFjNgMZ2k7V6t4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9Yt+AAoJEBus8iNuMP3dqCgP/jRnnvfe3ASZ+TlUjoXfBT0d
f2rIK7ZtB7skcnd/y+p96Sr1LXrTTwkxOzQzh72F5SoHixJECr8nm87ybaaDH+3V
n41MJZHhFA2O2T6DY+IbpvREzPPVo+i8hD42iB55V4td/8s6uIF6kEqJHIrZV6jQ
0Kjs+qNcWcFcGCnAroxZ4b7xbRSrui0TRhZH007xxXsm9pJlBtnGcRI2wm7WNDXP
JvXeOs353ucTioO6K3pGGk+Mq0+Euf+Uz0uDFtzh3EyhPg+QVs0zGs7nfui4L/lX
JbzHcJT9wQor4OG5FS+yuvI7sA5XylaDWQRUzSq8EejvTnwrVbuix9dzYIsueZNA
+o7WRMmNgI0P+WWOj5gxp3j/RsTk6POWxzbdLmdYsdcxgXQXceIyFKtZdtAZ8+FT
9WA8purF7dnXlxwxWUHzET7Z1Q6qpNaYcXfO6c6Gyf4ywvKrnFeGepybVhvnd6Ue
ipYZrtOqbQLP02JHeqx8/GytmV+KvCDevBPpM2eUJt6oxm4AIiaR3AG67yPki8wc
VKSggcrxYmjVrzjCIN3FftucJjesjbSNcenBZu73ezMFMWLUlBCFGVSj7Tg7DfCD
pDCUWSewSclTtCGhoOnE+jVTOuMOam8LyvLr5KYreCU2xqoLhmdYQ59X5VHSuElD
vMJ+TMDoxdxhMXvwQoIM
=XE3C
-----END PGP SIGNATURE-----

--PgFjNgMZ2k7V6t4+--
