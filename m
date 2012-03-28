Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2C1QfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:35:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48195 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758165Ab2C1QfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:35:15 -0400
Date: Wed, 28 Mar 2012 17:35:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Message-ID: <20120328163512.GB3232@opensource.wolfsonmicro.com>
References: <1332943273-22447-1-git-send-email-alexg@meprolight.com>
 <20120328144017.GV3232@opensource.wolfsonmicro.com>
 <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD25@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vx/u1Rx7tHHd/cso"
Content-Disposition: inline
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD25@MEP-EXCH.meprolight.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vx/u1Rx7tHHd/cso
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 06:31:04PM +0200, Alex Gershgorin wrote:
> On Wed, Mar 28, 2012 at 04:01:13PM +0200, Alex Gershgorin wrote:

> > +     select REGMAP_I2C if I2C
> > +     select REGMAP_SPI if SPI_MASTER

> > > I'd really expect this to be squashed into the patches adding the regmap
> > > usage for I2C and SPI, how can those patches work without this?

> You ask me about another solution?

I'm saying either I'm missing something or this needs to be fixed in the
patches that introduce the regmap usage.

--Vx/u1Rx7tHHd/cso
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcz2sAAoJEBus8iNuMP3dTJUP/3X7e7GGFaCyRNMcJPPhJV+k
YVTRzG9hSIXwFdGjIUIsL2662/Q0VudXkgRkTTKPHlHbMDoS1lYnJGGMuW5415ym
RfwSoNpWyEt0NuMX4PhLO/jRAPDw1SQLbDSZQ9Epc1OwhJTVXuTl1eDm2N3D/jLP
29iUlmIXn14iHnqNx6DtLMOVXIEacHXyrt7UJJbINPHUaSG3EFvqQjcGdomPWrX6
SD+GRATDZrJ63ZD6ltPjisGHZAT7L1XiW0d2T5KN/9kCQzbkVJj8huSXcHu6geO5
AbIYWGPYd3tnKLcKxB1Vf7PXJh2FH9KNduwz4w9RLRoPh4am6b9sWhSQuyqgXx7w
3tVilm9Kx0s4wp4UsmYHlLBJffLZ8zZrxUsc4rE3an1JsON+1RwIsHx8CdNd/IXa
5rIfmf00QfJIj4HCyzGZD2eTFAC3UHkjdL1b0ucpBSyMGhXeFtoUj8w21Aiiylim
Y4zNdtXUiNkRVSm/+BsWmNmfPwDZYgbHEsMAXqdby9655+0yr5fQQvxotx149V+p
JK+lVeSss8vaOmXuNAjhzM4CfQF9H4TAslaPSiPHq+H4sDllFmfkbv8ndzafSf00
bCmw4vGHWYaIKVuiI5O4/Zoi0/tFkNsTzy78mOs60FKMMVUNN8RteOYMeDCZPfN0
LMa83nBp/D5ctNgBEoML
=wf5M
-----END PGP SIGNATURE-----

--Vx/u1Rx7tHHd/cso--
