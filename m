Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2FSW2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:28:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49886 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389Ab2FSW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:28:19 -0400
Date: Tue, 19 Jun 2012 23:28:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2 v3] regulator: support multiple dummy fixed regulators
Message-ID: <20120619222814.GB4064@opensource.wolfsonmicro.com>
References: <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
 <20120618163758.GU3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181850280.23884@axis700.grange>
 <20120618172808.GX3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206191742030.6204@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206191742030.6204@axis700.grange>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 05:43:56PM +0200, Guennadi Liakhovetski wrote:
> Currently regulator_register_fixed() uses a constant name to register a
> fixed dummy regulator. This is sufficient in principle, since there is no
> reason to register multiple such regulators. The user can simply supply all

Applied both, thanks.

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4PurAAoJEBus8iNuMP3dpXoP/AsdRwci1m07Z1MomD7aDW6r
gVIjTfUYKwDaO50FHbYZ6IJkMzRSiOzLlJLsrr9lWLpF8jZYgGVyC/hYvHf5toN8
vlGvlsIJZoNYe0ZQd7r+dAry3AJ4WXs2IP5KITW3plQQPinNmIkqwqLd2LwEmTXt
xV0s0UG9XH/vu9L8hpjWt+89hNvsvT6WnvxC76jbSEEPPSrYlihzAvnvhdVm2003
uAHLgosRb1PTepSWzTKEOorlqxUd2RaQwqiPInWlCpZjlXk22cf17tbE69gsmK10
jLnsQzLIGdt9z2Wjn3ZUgg+LAT1pjLSIlFjRkCqciJsN5kUGLWNUn2VbiS2e4C45
swvwhQyI36nUUh8Vvl8RU8aO7XVuKeWtEIGneLqN3SwLHP5TXm6SV0lnoNGccaOC
1XN0a86e7MbO391wrxZ2leUT0p2mIBgxiA4Lf0tNH0PeHO8FNTf9oiYkGyZ/Q+9Z
koPvmCgG+V+VdfLkv5OCAHt81KPhbfdWyrGTBd0tjloQzbIsSwNlSftreJAzN3r6
Td4Tzs/i3BQxdVWNVcbjKA6ocMG7qC5AeKzD+lIBPLxfn2XUrixjJIkU+sMINwhE
U23f5jG2GmiEe2VfeD/NTDrQyFBHHSNg6Mr+jyGqyUGVSWspLB2AgYSnOYWkH91c
uxyYZOTP+/BAffhkRL7s
=GHfY
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
