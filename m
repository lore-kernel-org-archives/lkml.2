Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2FZJMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:12:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34588 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908Ab2FZJMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:12:38 -0400
Date: Tue, 26 Jun 2012 10:12:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120626091235.GJ30406@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
 <20120622084228.GD4037@opensource.wolfsonmicro.com>
 <20120622085909.GA24121@avionic-0098.mockup.avionic-design.de>
 <20120622091238.GF4037@opensource.wolfsonmicro.com>
 <4FE97AA9.7060805@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOcTNEe3AzgCmdo9"
Content-Disposition: inline
In-Reply-To: <4FE97AA9.7060805@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zOcTNEe3AzgCmdo9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 26, 2012 at 02:32:33PM +0530, Laxman Dewangan wrote:

> I have not seen much oppose on this series as such and if you are OK
> on this then can we apply?
> If it need to buy some ACK from different stack holder then we can ask them.

I've been waiting for the ST Ericsson guys who are already CCed.  I
generally give people who I expect might review at least a week to do so
before I get bored and apply anyway.

--zOcTNEe3AzgCmdo9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6XzoAAoJEBus8iNuMP3dBM8P/1NJe+Toa8fV8wOM5YvRcuYf
r2uqdOzKmxWiGIf2GzTKRQa1ElpAdnr1kw8AD5fVbJzH4gw3QDhUVOfezGbhvbM+
se7Nk9F2KgQqyDMXOxN8E59kKONFDVAi9Uh9+D1ETFCmXKBHjV+cjde/rysEwVZp
LW3kCsjsGvEnfB0imG5soY8XQUA1jMNYK9ISuIDE5F7p2BRdUDA7nJ8CUV4mouvE
7OcYEuyleF8gZYfse3pMiVsW8Fvh+4bDC8eE/F+YOszvfOmB/0vR3QipW5JTmqae
YFKO22p6EBY9nt/A/UuvvpXerFQpPqGXUBdZjl48QmG4l4L6TYjbSU0S25+b4vck
X2P6g89Kc5poDUlg9NKCyQWZmaJFjOutyCeRJH1fli+gv4jZBEXNRkarvGa6+vgx
SoZZkS41moMBpEH0r1R6QSq8izw4GEpmFswgR/r5/B6ibToeMZVi+yoz1sbLlpYr
LRVBYrjRjZxcI138xEYdkphfFMBFIaS0RbEDIyb12/wp+hk8wOTjl1/zLvbB726a
z0WaldTB8HXovipsBUbzJI8qWmVeb+cvr+m9UM+YijX3Vlhg6352phUuJL67GMrW
5VwCt0XFmyQFr0IeuGKcaUhZZREmstm4GCkHW4Tfe4j9M1MRC+gjEB5ldo0E3/Ac
sXfuiRxsMSFLYF3UCf0E
=H2Xb
-----END PGP SIGNATURE-----

--zOcTNEe3AzgCmdo9--
