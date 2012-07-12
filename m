Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab2GLRHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:07:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53821 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932725Ab2GLRHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:07:17 -0400
Date: Thu, 12 Jul 2012 18:07:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, SamuelOrtiz <sameo@linux.intel.com>
Subject: Re: [PATCH RFT] regulator: tps65910: Remvoe
 tps65910_reg_[read|modify_bits|read_locked|write_locked] functions
Message-ID: <20120712170714.GH7256@opensource.wolfsonmicro.com>
References: <1342007053.4362.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <1342007053.4362.2.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 07:44:13PM +0800, Axel Lin wrote:
> The tps65910 mfd driver has been converted to regmap APIs.
> This patch adds tps65910_reg_update_bits() in include/linux/mfd/tps65910.h.

Applied, thanks.

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/wQ7AAoJEBus8iNuMP3dyMAP/RcD+nvg3sDJ62i7IuFTWlTm
r/Ac+GKuwELN7FSJid5ehJChxsNuvRRYCK9NMsNJ1HxxEiposQU+5k6ZIgP3V7us
S3WdBLQyOjN1jJF3itKVaAXiE6MTULMChRq3O6ucHX4iEGVOFr2pkXx8W4nWO6Le
vh1vtV7nJ/wkAd6upPdJ0+0aD7zU+5MaD2HSWUDmmX7DFZRVcRu0TDDhKwqbb0s6
yL+M3wn0duXhf9o+O2Y1v20j5Sv4FBBpaz8NXlWhOmc2i8R5C5evyn/Oe83hAQfG
UM9ozAsa8lErbQSWG1CTqaIGCy8ssMnvgpMkuLsJMLJ80j+ZQwvWST9oBVzgvAOd
kxQ4UDu7P0FdOB7NW5ITAOGEJFAuhOduJGyIvsFoV/UfnrJX9hK9gHPcze7g5jtP
uYyKfcVnwzxzexws5P8kXYulWxKwNRfapv0GtG0bp2JLoNzTguDzI+g2rZDyJCtI
2dTlozk2FlkTCQMnTDOYgdxLLQ534wwtjiWbU1+rxZshgLTsglu28X1V2OVYYLAq
doFEoLcB7Ub5xQfmbIGIOhvhjLLErlcvSe8uIwxNSuGLl8czFQxLmQcf7mvMvtaK
1ZCm4ddQg3KxX1gHbe4jwFsl4tm+iw5PuODb1e4bXZ8Rpv3oCYOVJneOZCIdmY+S
1ARs9csUoN0hwWi3hzgM
=pnJz
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
