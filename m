Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2GPT6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:58:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47384 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab2GPT6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:58:00 -0400
Date: Mon, 16 Jul 2012 20:57:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, rob.herring@calxeda.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps65910: set input_supply on desc
 unconditionally
Message-ID: <20120716195756.GA10774@opensource.wolfsonmicro.com>
References: <1342446294-2644-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1342446294-2644-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 16, 2012 at 07:14:54PM +0530, Laxman Dewangan wrote:
> Set the supply_name in the regulator descriptor unconditionally
> and make this parameter as required parameter in the device
> node for successfully registration of the regulator.

This doesn't apply against topic/drivers, please check what's going on
here.

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBHIrAAoJEBus8iNuMP3dTcoP/1xS0IJP0JYlk7oAeYhtV581
zGsQkC9WCQqDYdbsEz7c5ZCI0v92mHPbvONs0n1lBNclynyuIggj7GuNM7w1SFIE
jwpwCZmbHSev9Z7JIAEHK4c5/nVV0SSnX0Eo2/toMmS5SYtPeU55FMfBd4YlBJH6
GaZTAkCjNcOLM+GApMkMXroMpe38Iw9rF7PlF3J5nobSKJ6iSXFeiiRO5JItZ7Zo
PcLHwKQVWkW4zL5G2VUWoRT5reYq3vHke+A7v8YDmjGv4NSYU5JOmo97zvsyiu77
B+bsXl5uwm/zgInfeSpPMinCoxXVI4TKvgoeWgf4wj+c9pJzs9EpmqUKykFPMEno
/vuqfJeYLfcIzGYcJWipdYp3bHU48RN1Bz8Ell2cixtnpBwpNZ9TosERX6+m1mOb
9aVUVpba28w59lnK7BTnm095H8YMIgr+aw3rFCA8yCJKOPJ3jVL2ordPxGJRGw1m
DaSVSi+uZVtV5iWJ3200WSAsaMIg+eiN61nPu+Yx/tp9zxl6eyA07n7sFP5Jup21
bCs8rnFeqN7GSm/qoim+ZhpKnwfuAfgR06IOqo13KDaHcCqAZHCdpEJFccmI9yCt
WLT1+HO+Imok88t6E7AiZJcEz65sxZ5nmWiXWWYtAvozNGfZO3GJ4/k6a+1j0cIa
inMJAIfz6gHoX6qhM1TM
=eV7c
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
