Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ERPgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:36:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58635 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab2ERPgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:36:41 -0400
Date: Fri, 18 May 2012 16:36:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/16] regulator: Enable Device Tree for the db8500-prcmu
 regulator driver
Message-ID: <20120518153636.GG4039@opensource.wolfsonmicro.com>
References: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
 <1337330355-17747-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Content-Disposition: inline
In-Reply-To: <1337330355-17747-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 09:39:06AM +0100, Lee Jones wrote:
> Here we use the previous regulator register code separated from probe to
> register each of the regulators mentioned in Device Tree.

Applied, thanks.

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtmx5AAoJEBus8iNuMP3dlvAP/jKC6FyGFYSA2UM0lKyDZ1XB
9Bizx+fZPi9VT9vPQ5lnNrCKbadE7+6Tjol8+Z8RUhiZc6gSMpo1sg4B3uOxN7Xd
HcbIxQjByEaI5cOXHDCvOOPAbjVkG0NnHAHKQTFft/9cTb7Ay2pSuUD4MFeDDZMt
w3YtH3BiVDeuNZukmDcP5NfBhJGsJaQFWzccG6JeTEju40W/pv/rXJMLosHAW40q
UbsqpjYdNxS8sJ+PlEcJ/4EumPLZxaWfJAMgkGcR4P6th4tAD31pDn1N18te3jZO
cYzU8Zlx5gx7erFG5R3DHldb3BLS5p9h53Y84jEx5UPRO/PYWah6pqox2OaXfvKp
5EwggYyXMbXa68geZb7WcbRn+tGlmmf7ov8HT523Uc3vt4Cj/HSZoE1ADck8cK+i
2+8ScxpC102sRXw0lyCa7PMC5A8ueA+K7B4YUYhsU1M2X6/rN7UxiK3bXt8bs2Z9
W2FUEG3HRHs+YaQ0Y2RdJLLAHIgFRdOnEn/XQtR4Fx2O3JOH/PI4lZxE4gzYcuIo
tB4ZBKMSCW7DT5AX9QYSUQx6XTjQe5ykmgv6ZYRYbQJ/cJC4/KGPfmv2PhikAZ4I
0xxCBckmW4G4G9A0vrWhu+QlVw1QudAxG32S5HLbESPk5vVNC5MuR0zZAzfznRKh
egJdmOnjQI61lG5VNlWI
=/UZa
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
