Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2GOVV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:21:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49349 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab2GOVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:21:18 -0400
Date: Sun, 15 Jul 2012 22:21:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
Message-ID: <20120715212114.GI4041@opensource.wolfsonmicro.com>
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com>
 <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
 <20120713142229.GM4215@opensource.wolfsonmicro.com>
 <500057A0.1050108@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LFBTxd4L5NLO6ly"
Content-Disposition: inline
In-Reply-To: <500057A0.1050108@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LFBTxd4L5NLO6ly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 13, 2012 at 10:45:12PM +0530, Laxman Dewangan wrote:

> I was thinking that 1/2 should also go through your tree to avoid
> any functionality break on existing platform who are using this
> regulator.

I'd be happy to do that if the ARM people are happy with it; just let me
know and resend the patch if you want me to apply it.

--4LFBTxd4L5NLO6ly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAzQ+AAoJEBus8iNuMP3d0WAP/A5PwYChGg8POUqZiQEyxdGC
5uyLG81AvkS2vz5WNVktM/fM55mudtHScY09kpa1pz1fn3won7qZFYnm5C9VHQEF
GlLktGRGc5jG7rFivlEbdrUDaB7qDhBIHTD45b1hkUTPxm26/cZEDXXNqx4TKSe1
32ELootKEnQdvrmRSJt9/Wha5wLHMk00jgRWXAWivYvuY33bk7wxyrQGoNkxvHT3
rkdDYAmu77370+s2u6lzPs7+gMRwaFBZCc9o1T3FYqZSxp/RBDc3vRVXKp5MtePh
KiIJk1Xt1XEnEHY6nE8xo68B7rMeRSzo3xu3AT0vAGGP7xcn5Van2RJaQXEuWkI+
xSaCrQYZBo9jIvFVhS+5TV8bomykQKrVEceeKqOn9MHJZAkjm9B5GAsJ7rZnj4vX
Uw+/U4HxO6DP3o/d2V2j8jjCg8GpTe7iUr0ZMPLNSGQxDfJrpfmDMHz6lFjdSY6+
ZRfPbqAa6n6eTj8HCqifkhVXET+yW9LBmRT2i2kD7nUa7okZBA9wFw2Xax8MZLqP
aUaReVNmrauotO6aysNGDVKjGaCl/pGTtIo5PUtzZ6IzSmIZKGiBh89n7ZwiI0v2
dLpC6b6YVqtFgurmBssaPkSjkO6Vr9SL1kpF1cCLaIXFyWcoG7iTMD/ql+gP9l0/
0zFMJHAGRdycz77C1jO3
=7Z0V
-----END PGP SIGNATURE-----

--4LFBTxd4L5NLO6ly--
