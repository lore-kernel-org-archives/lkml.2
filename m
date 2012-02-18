Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2BRUAo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:00:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55160 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540Ab2BRUAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:00:43 -0500
Date: Sat, 18 Feb 2012 12:00:39 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Remove obsolete consumer_dev related comment
Message-ID: <20120218200038.GA3198@opensource.wolfsonmicro.com>
References: <1329576795.2399.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <1329576795.2399.1.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 18, 2012 at 10:53:15PM +0800, Axel Lin wrote:
> consumer_dev is remove by commit 737f36
> "regulator: Remove support for supplies specified by struct device".
> Thus remove the obsolete comment.

Applied, thanks.

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQANgAAoJEBus8iNuMP3d9x0QAIoWlvhJzzl3STGxF9qthvBo
rUxZgvEuaM7YNlhLJdQpukg/42hw31gOs6ilgoAoSrswKSKF1r5K361OOTJ1J2Aq
tCSadlGBXnZD3JVjbOZ23DpzvxRMog8cMK4NzxVPTLUzfiRd+JEjdEj1x30hvD6W
hTtjyHafFBKdsO2GiMcrUQfggGV7FHanGDaAyYkKvFCcPzx4dQ6yx7OHTj6U6OEV
GNQtSykfZHTabx8hE21k4N9mO34OYLxgGEke/4A6ckaOPDJ/SOBuvGr27aFUJToM
SCIHN8q0A5uIgU2EyWkj16+0UZZzLvz/V7YGnZu4UTsTTAoWgzWg3f8tb021tRi1
RG6oO+WmXhO8ceUFJet+gMp/Dk0umJAuihSqdoZYos+zb+H3udU73/QfnKEse/Dc
TiNQtnhBSTbkazCPXBMj6Pd+goYoURWh7fKKeTovQiORH78vkJb6UOPrOnrcjlCA
Yd2PfUs4gPFRTASSQfKP7G00cijmmq71xYgOR/Amu71nSM6i+dWga+pNcc+JHXGY
79kCAlzTKmw1gPmnWXPbGZWpyRTGz4EdFf3S1bmfQugI0+RFWSOBRGzTsO39/E7C
wO6PjyPDQ71CNOP9Hg8uw0gwCF0rqtZyeSGdZ3bSVehaduCFvmlQkEWVqqoJNXUg
Nb+/X9lRpM+2sxKpMp5p
=QtDf
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
