Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2FQUFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:05:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41819 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab2FQUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:05:08 -0400
Date: Sun, 17 Jun 2012 21:05:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: ab8500: Use
 regulator_list_voltage_linear for ab8500_regulator_fixed_ops
Message-ID: <20120617200506.GP4267@opensource.wolfsonmicro.com>
References: <1339122469.5794.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ga5bsqHr1s/xcZEm"
Content-Disposition: inline
In-Reply-To: <1339122469.5794.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ga5bsqHr1s/xcZEm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 10:27:49AM +0800, Axel Lin wrote:
> Also removes set_voltage_time_sel callback from ab8500_regulator_fixed_ops
> because the voltage won't change. ( And ab8500_regulator_fixed_ops does not
> implement get_voltage_sel so set_voltage_time_sel won't be called )

Applied both, thanks.

--ga5bsqHr1s/xcZEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jhrAAoJEBus8iNuMP3dWeMP/17EMRml7noGWAoVYwwWcYDy
Hr09uWiQ7e3jS3BDpTAkDeGDpGZhIrckFGOZQ7qyek13eiUIiXcYz6yAwlTfpxyJ
Y2m8sMDacSzy3R2sbpVCjMWsmfM9wGZIM9OZsnHSorVtABgw/74DBnpsw3FGf2CE
EnxSlQpnQVMrJ2wsBga9P9ClwTAHckpcpOnohh2zksG2yF/wJfFjptTmz4otLiPb
vVg+E7RJIxBBSFq1lZXr/LeUrqDx3EnlbgXEorv1wADDDJjYd/3r+7bIik53ww4P
KePZ9cT5fDbB2qrZKYVOUpym0e7joafEyQez5cdP3ssVLnN2PshkziuPgfv9meKR
MrZahJeja4dBO8zj+PhI/ZUjoQxUcGvVUEOhHgSaxzPmQW1V3fNyjVdFsHfDaF7o
1+GjDzsTA4hySv0wdKF1lChcAJN723Ch7A9nq4V5+UNV/pOPIUMxfqxhxsqtkaaw
z2VAOX68ZQWpG6QbKrJE2mhK4nmpMirw1eIumQDrAov9E+OqP5OSMhfuHnqFWkFj
kqlLHZ04w5OjtO5SdPMkoZI+QcB2tjChvCvDZZKH49xPJXc6OEXJ9LB7oN/ANryE
jYheOhm4I0tb21/KOpLFnmwgftzLjM8oYiOQDSn/SDKZ0fPwMpxSp256XcnZS57r
RivpHrGKU14k//BvxfzC
=vmtJ
-----END PGP SIGNATURE-----

--ga5bsqHr1s/xcZEm--
