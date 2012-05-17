Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966872Ab2EQWBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:01:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54643 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965954Ab2EQWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:01:19 -0400
Date: Thu, 17 May 2012 23:01:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: rc5t583: Remove max_uV from struct
 rc5t583_regulator_info
Message-ID: <20120517220115.GL26337@opensource.wolfsonmicro.com>
References: <1337215845.5759.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7PTD44AewjTsiSV"
Content-Disposition: inline
In-Reply-To: <1337215845.5759.1.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7PTD44AewjTsiSV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 08:50:45AM +0800, Axel Lin wrote:
> This driver has been converted to set_voltage_sel and regulator_map_voltage_linear.
> regulator_map_voltage_linear will check the voltage falls within specified range.
> The max_uV field is not used now, remove it.

Applied, thanks.

--C7PTD44AewjTsiSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtXUjAAoJEBus8iNuMP3dSucQAIHGbUjn96NiPapga851rftL
4yq++tp448Mn/FMnKxQS5/OhwlaHuAQxRul3f8fE2TMUl+p92LTBoSGwuimEL+BC
7eSbC3EjdCYs2dGe4lqIXrDkHPzT+EHu96qqdBKCuJ0BFjFuje6kkfoBvGnXiDTo
v07XMIttDJM7CUqYkfLd44YtiZOwAKJut9I6zaYxtgcylJjflf4tSI3jB+w/dpDI
xh8ayKhNDn3bxzhP/kLkWMwsjlYmeUrqnoESf/u844033W5JOMJylLm9ZiB18DLw
3IglAVW3i0Hu2japQ2aeL63WkjGvzbmfxcbt7EvR80f7GntAhSQi6TRG9hPUfjvp
I3i35hK4U1lmFCDPM5O6iyKkNByuwYx+Uvrhl9NMdqqY+PvTBYDUUGIGvqfMLVBO
+cKU9+aD7IBKJCsgr4xS8yVcrVZHb2tt3A4eulFIpG3hZ3dOxABs1Ge2V7DchhDv
Z7jSEF+prDMRLjAg32Fs0DSwYeRxYpIpmjcRT3yNPZg7aDzLm/c/CUTXDi1UPL6p
282+SdWlAnNgV/ktlIgSxbW53t+SGhXCecQeg+wFLeOxTNmiYwXmforfHeyagXjI
dt/dApiowNSpEbTeSyPEBk2Bl03LQqTJjI0RZTkRMs+EMNSUMd0KFF9A16Kfmnmh
1m2dOnqL3fuRPcVXG3N3
=Xul7
-----END PGP SIGNATURE-----

--C7PTD44AewjTsiSV--
