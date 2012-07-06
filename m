Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab2GFSL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:11:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38868 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab2GFSL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:11:27 -0400
Date: Fri, 6 Jul 2012 19:11:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, lrg@ti.com,
        swarren@nvidia.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V2] regulator: tps65910: add support for input supply
Message-ID: <20120706181125.GH5437@opensource.wolfsonmicro.com>
References: <1341564192-18154-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <1341564192-18154-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 02:13:12PM +0530, Laxman Dewangan wrote:
> There is multiple voltage input pins on device which
> takes the voltage input for different voltage regulator.
> Support to configure the voltage input supplied by
> different regulator for each regulators.

Applied, thanks.

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9ypBAAoJEBus8iNuMP3dWwIP/jF2h6BMjXPzn9vwmvQxM5eK
rLvyPdnyavTbCQ0jBvQiNntRVStNaA1WexmwwhFL3dtyV3yIAf2VI3MHj9PZpk17
m79WmDGcFrnjrNpEyzNTpuFgrkv0PikNC6iusPNvNk0TrwfMtTx7G3NLc08edqIS
KgFgozuNjWiXjmsevokFsZCJDOvZroAW15mjafA8Siunmp9I0iBO3FQairk70Xfv
aqoK6CSEu4EdFN3B/eKILzPYYuExjJHNewyv9YVwUkpJOUT2T4iZz/XM5pJr1NYu
BFIJc7XINHvhLZJ0qB0v3aOThjVoSLRyHDVAWyTXaRpqntp2BgRxvN720ZEMozUa
9yxlv9NVKcuOJuge7CPCqqcxI2phBfIF5YujF3INH+p5z0o9C+vNL9lfNywB8IWR
RLunA7edw79KUhazHJI0engPA/oaljpxHpgYg/zmIAyLFXZcn5DyMhakfbDUlvf3
QYu84GemUD01Ol5BslvGZFIs8un3QVU/daTJ/93VTz/MH3hy/w2eISTNotTtoPN3
WzcSFlYwVb5b+aGQLKCJog8DSNSQZV3h3s4CPWYzVl0T/U2hp32moGDsyJiUk1/j
H01dlt+vSLXutoE0OwgDxYr7k7zgmSrPxxDFyfmeDAZmwJKJw0GpjdPFxu0m0KhR
t+tsJOPkoRKKcJkH2Cx4
=MPvh
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
