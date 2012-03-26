Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2CZRcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:32:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57915 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933093Ab2CZRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:32:46 -0400
Date: Mon, 26 Mar 2012 18:32:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix unbalanced lock/unlock in
 mc13892_regulator_probe error path
Message-ID: <20120326173243.GD3789@opensource.wolfsonmicro.com>
References: <1331786949.4709.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Nae48J/T25AfBN4"
Content-Disposition: inline
In-Reply-To: <1331786949.4709.1.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Nae48J/T25AfBN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 12:49:09PM +0800, Axel Lin wrote:
> We do not hold a lock while registering regulator, thus should not call unlock
> if regulator_register fails.

Applied, thanks.

--6Nae48J/T25AfBN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKggAAoJEBus8iNuMP3dHckP/1su9Ffb8nP86msRK05APTfP
aXVjPtspyV4gKdoju1jJnDSav7zQpKCy4TeGOrMaO3vC4vvPxwUgv76p2kSHOhfX
MFa8z/P4AlFT2mS7Tzm38F5/R4Vr8TEhu/Yzv8YMcyS6Qk7PjJxlx9WP+7mvcVAw
L+oV+fiAg8UgXfw0e4xaPo9ImBmABgBiSkVKLLM8jv6bkwZBR8ADN1Nqxg1Wy+pS
FpniYTB31ZvbexlEw+WIJdm+i6d8Al421cOI4Sff9BgFdzyemMg72TVx+6uJfdSB
5mhJjic48cXvxo1B/78hwPXValL7eP5QzsawEzGCxYp96F51QrTEBNXyp4X9YJTK
/6uKsZtg94NkfmVoiFgJxlAU9UGZ5R0YapubW7XeGWOS04S/phy3KIDWZZlur4Et
yZnxDOwdf82hLnPpUlyttrqzPBdQwWgmEsBJBDzk+V1aabTP0Q3TKj3L/Rw0u6oL
JQNr+f6IBf8TKTObFLkTevR/aSIRK5LcY/73d2Nmibzxo5kYl2x4BXUWMQ63/kDz
ZBpsPmIZ6yx7PsKkjetZuqSQvZ7qMB/fDUOxoSYVBHRoj7+osaFnVBV4yz3IDVRA
bzUPW68nzOEzoAEpKUTkacTAgu+FYEsPamyuCmgMr2i2lnrColUtu7CZP6n91/5g
l/zAyu9voSvF+hyZUcaq
=S+sW
-----END PGP SIGNATURE-----

--6Nae48J/T25AfBN4--
