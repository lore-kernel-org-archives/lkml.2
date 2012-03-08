Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2CHSHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:07:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36756 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab2CHSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:07:31 -0500
Date: Thu, 8 Mar 2012 18:07:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix setting selector in tps6524x set_voltage
 function
Message-ID: <20120308180729.GT3638@opensource.wolfsonmicro.com>
References: <1331172137.14592.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NQqDiQVflaif2hna"
Content-Disposition: inline
In-Reply-To: <1331172137.14592.1.camel@phoenix>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NQqDiQVflaif2hna
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 08, 2012 at 10:02:17AM +0800, Axel Lin wrote:
> Don't assign the voltage to selector.

Applied, thanks.

--NQqDiQVflaif2hna
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWPVbAAoJEBus8iNuMP3dlTQP/jcvFjLO8JiOt251j3hmcTrW
ahE+NOjYbcfqpNBcUPHzNhuCJnTa2qie0P4IpuPqy6AmHtRB+Vd9qzkKts/SFBsv
oonXAIk2M+gJwk4JQTG/AwtOV4OIP65tsZ+XnrmDrlipKoOqiFIc7gfzM3ffk1YJ
9fVt1z3WogP5kcQtyTXXXFcBu8M1+D9UZJTkVE5RwMwfOZ6KGW/4Qo2UbZfoTPfp
Y85eJNSEsm78jw+jQHDbrNk9zKT4NeS1jF9ZuiuCZgoQbKtRzttiWK4XOeDJ/uW3
rFxOnuwRblaBvfvyULuLzoWp4/K6jwn/GblGidTQ2RgtkWng8b9h5s0Brl6be21v
420qw7Fn4p44rIUQzs3PF3URV3QXVmQZumUtXl478v4ij5LvsaPZkyXExdG+UN5W
O0mOZjTnFzaPyN2U4aachHISz3Doa1zCuYlPEmpIZJcdm9JENuu1P/IeKUlw+qrh
KqtqX7/MtWiTOtg0ZhOxeCRyRoDHdu14+m0zKwK4DiGIL4nAwno+dbNOLw8ZWNMK
UqcSt8Ikh8JSYY04UESVH6D4x2TVpNkWGbnYiHyCGOiqHUaYrOU7ufgqP8tW3BkY
uw3s+GAE/FS44A/nnbE4xHpMYhuRxc8Z8j4ovlruD3crb5nEAtLhbqR2gDdiUAKt
r/Ixxip44T4K5C3Mxhwd
=LrGs
-----END PGP SIGNATURE-----

--NQqDiQVflaif2hna--
