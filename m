Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2B2X1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:27:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54359 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184Ab2B2X1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:27:32 -0500
Date: Wed, 29 Feb 2012 23:27:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@openmoko.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC] regulator: Fix n_voltage settings for pcf50633
 regulator
Message-ID: <20120229232730.GD8295@opensource.wolfsonmicro.com>
References: <1330490735.7885.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Content-Disposition: inline
In-Reply-To: <1330490735.7885.2.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 29, 2012 at 12:45:35PM +0800, Axel Lin wrote:
> Current code has off-by-one n_voltage settings for AUTO/DOWN*/LDO* regulators.

Applied, thanks.

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTrRbAAoJEBus8iNuMP3d8ZEP/1EntOFpOsWzK2OCH11ZpDcv
TpAuGDAc8amNtlBYFNfkYvKfMtcsA1VpdTB/bKxBcdQk8tFqwBDGknG0NcQR5KLd
7VFU/h9bsz5knVAVRItxVnl7A+MthzHvwcDy7kdhJ4+Kv2vLCgWEmmoovUrYasqk
uzmwT5GPhenj8WqHi/HbVHVPrr5WgkevE0hST3vL2tk4wtDDg9z/aKkMqdVXEAqJ
zBEd/uE9LCcpraikVnalg7Kyoq0rrxccIl2CxW2Lb+Qk2IfxEEVSYYPOOroDcJta
CFBbKW3unRZqjYALht9i4W7bFpRibbSLeZxJD5X3KBNSGOYeW42bwT9cA3ASJwTI
PJkrBFnv+UhJBJTKef7qzjm8mV+wkxq/t+KaXGY2kUMPU+/oKirgW4VIGkUkqioX
L4x8YQLLOnd3NrqU6N2YwWnxJnyNNfdWGPLyl6oA22Mf+fQfeCWatpilJhmzzd+w
raqRzb/qwT5+PZ+LCLaVTj4o6NiwkmKoMPmYg00JrhsPcE/uc1ORdUuEK8w6WD4j
CHhH7MzoV6pUsYC4VBkr9/cRok7NQMxpeeLKfi6bILR+41MEmakTqnCCcVlW7Kgg
MzjS6SqHjQOWKswmxzBMnNbctGDJM/JU0TY5zWjmpA3epro9GENnSoJTuJngl5py
9DsK80ZM+V3rNG5pcw0C
=m5NU
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
