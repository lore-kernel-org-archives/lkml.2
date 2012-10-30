Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2J3PO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:14:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35083 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab2J3PO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:14:56 -0400
Date: Tue, 30 Oct 2012 15:14:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] spi: tegra: add spi driver for SLINK controller
Message-ID: <20121030151451.GT4511@opensource.wolfsonmicro.com>
References: <1351531104-1604-1-git-send-email-ldewangan@nvidia.com>
 <508ED5A5.3000703@wwwdotorg.org>
 <508F6906.7020704@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e9fMjeYs+GPci+mg"
Content-Disposition: inline
In-Reply-To: <508F6906.7020704@nvidia.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e9fMjeYs+GPci+mg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 11:13:34AM +0530, Laxman Dewangan wrote:
> On Tuesday 30 October 2012 12:44 AM, Stephen Warren wrote:

> >I think it depends on DMAENGINE, not the specific driver now, doesn't it?

> Taking example from the mfd, we depends on particular driver, not
> from the core driver.
> I like to have this depends on Tegra20_apb_dma.

The reason MFDs do this is that the function drivers usually directly
reference the core driver in some way, for example by relying on data
structures it sets up.  With DMA that should all be hidden behind the
dmaengine API.

--e9fMjeYs+GPci+mg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj+7JAAoJELSic+t+oim9cLEP/27j1SH9q3Pbc/epbs1hqYl9
/klO4ftaYVHGxgs1v/cpUUEH9Q4hDIpMKilXhYoz4jDStC4HZF5N+TU1ZgdZRg/Z
SH0sJwZzYr9aFBIc3nnJTsJ8/rWM77CArG9/LOugPrmvdALXesizZZkkVWv9IC5K
sw7VuvimrbnmdPeqf3h7R5UF7nHCPWCNZYZKXwI4l3VmpvVtrKCLFrSErYZw6ySr
kdRWfg2bTZA2O5oQ6sxplLUG5ZDjsBEoQHeDXTp6TmuXmU72zldkl3JG8EYNGIZn
wJjFVMgKt1iXIhKw/1trU2CTgkji2mhoc96Y6gIFzuDE7cLXpuauzlV0oyIrqTG7
q76CP46bsaSPGsXB/5jYBNvFdPGXM994lFbJlGSsXdOQCw/leeAch0Vg5UhtMtHT
bYgYotaguzK1SUAjEzi9dHi3JFuSF4gzVbZaHiahUJlTC2mcBFTwjng5cpYWuTrw
JXzxmXxIdt+CjHyR/A2CXYuUEU1/5Zd3pDY2nh2QgP0yV6tR5P0JizhoYJXqd9xO
QavwUAj+/rfX2vnW69o36J6KnNQNu7m4JcxZwjlKPoAhftu9cRlPMpZVLmOLHZ/Q
SAeVQ/71++3ZvwzcP8s6BrMuGZG2tUvTTGiiqKWMn3m1KDSlseHfdBufbj2jpFwu
jf1hzEb6LEUuiTYxufaG
=2lpI
-----END PGP SIGNATURE-----

--e9fMjeYs+GPci+mg--
