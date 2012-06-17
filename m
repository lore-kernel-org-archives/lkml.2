Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2FQUBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:01:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40157 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2FQUBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:01:40 -0400
Date: Sun, 17 Jun 2012 21:01:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: mc13xxx: Fix voltage checking for
 mc13xxx_fixed_regulator_set_voltage
Message-ID: <20120617200138.GN4267@opensource.wolfsonmicro.com>
References: <1339141174.16616.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Content-Disposition: inline
In-Reply-To: <1339141174.16616.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 03:39:34PM +0800, Axel Lin wrote:
> The voltage range checking should be to ensure mc13xxx_regulators[id].voltages[0]
> falls with min_uV and max_uV.

Applied both, thanks.

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jeaAAoJEBus8iNuMP3dRAQP/Rsuvlz9dHfyPc59hHNTsJ0W
K+F87ycxa31BpiMffl3DnQkaM1Xpt87PX1tWpBctkiRnPHGVRuApHckj0rai7ZKF
Utz2MkhUuDTyblhe059zYD1hl+WjJjlG0WGFwiqGrr+gpeCobcNM27k4WqCDEbVT
vX2WXzXo0NHFVJ3NS1J4z1hnhZlByblb2XscuKIY/G2Z8IA7gWYsQgMMJwsp4FxA
dVaTesfz10MxelZvj14hEp4x37zFqLXXS1TtXojUztODZhduvefvrITLW1kBl63j
sKS8WLxsTf9Ap3nsQm2+DfF4pMPVA98PQRIdkVDC2HHeiSPdmLnErS+Cwwwdw5j7
3t/Kpwev7GZqN4DMJs9BhQ8lfrZ7jiYgUdmQROrz3xnPQYj7POCfogFCv9dIvrs0
E7RP0cr2nfhK3CgNrokAyo7ngHPK4IOIibVy6UThwZCT/QtNMh+vJRjG6TyC8cnH
Lt1tQZrZJKjKDCm15Qv7rhVSJmFCQOKi6YZ0s4rqo44pcZT2XJgywUrR1QQxt+Fs
TAiAHU/AhAPb0dfZyHPYZ3FMfHX3NtPmJyPZ4AtdC3Vehr6EJnT9rXNL0vVGia3s
pPOgHqlGnuhLI6PdiXD1ITJ4NRG5lqbRD9j/tSG0rBEOp1V0fql5kXvXCeFifzB9
w9HI0xR4ocnQulQXO9er
=tyiz
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
