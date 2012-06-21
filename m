Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab2FUJxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:53:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759227Ab2FUJxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:53:07 -0400
Date: Thu, 21 Jun 2012 10:53:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, lrg@ti.com,
        lee.jones@linaro.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/3] regulator: dt: add policy to match regulator with
 prop "regulator-compatible"
Message-ID: <20120621095304.GN4037@opensource.wolfsonmicro.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
 <CACRpkdYSLiLZwVwY1tU9PWGTx2EGP6OykeXE5rtwRKAHror-Yg@mail.gmail.com>
 <20120620100058.GD3978@opensource.wolfsonmicro.com>
 <4FE1F918.1040909@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ll0BBk1HBk/f94B0"
Content-Disposition: inline
In-Reply-To: <4FE1F918.1040909@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ll0BBk1HBk/f94B0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 10:23:52AM -0600, Stephen Warren wrote:

> Related to this, I wonder if we need some scheme to tag individual
> bindings as under-development vs. final, and some way to promote
> bindings between those states (a bindings review board?!). Do binding

Part of the trouble with this, and the reason why it doesn't really work
for sysfs, is that people generally don't think there's a problem with
the bindings until they run into it or until someone new comes along and
reviews them.  Apart from the OMAP hwmod thing generally we aren't doing
anything that's not supposed to last.

--Ll0BBk1HBk/f94B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4u75AAoJEBus8iNuMP3dtSwP/2Gt8hBG9EzKbPGwnowrBXQO
IHEhxpGY0xp5WCmZoyk8Q5/Maf4v9bJn8pd9wsO3unu9/sjxY8EQoRWKmLUJP2Rn
/Xy85Ws3+fUjmKusNrJxjf4A5syfvO3q+wTkEgEY5MW0EI9ZVB0aDY4+aGs0XnYm
nRvJXXQNPBNR20pqcVCVwdZS59tkTdGK8aejzNmZdgE5D7/WLzHClgu2YDkqQ41G
wbPNNV1Jd9KUGNhq9bzUyloyyJWVCi/GbknsP8VjzJF6DrnnD0h3As5hcIj3kE4/
BMzwCpZZM9gWvVwj/yjnzaUa+F6DzCenofMwcKqUOU/CS8hFPS6snO6qiR9TvKEE
AvG3vrk+vg/wObG4mTuCPO0LHt6SkQNNfECOSr/jZBZs8V5peEM/35v7v5e/8gMV
wbWNgcuUwR2PGpwiqZgSZpg9L0+m63WVBZQJkxetikBv0OLgWN6eYH+rVrL2T3yp
8Ol5+jjTiOvM7JlKMSyfpcx0nP6fN0gSTZOOWMHpghMq1vV3BcbIZxydRS1v2zBP
wUjT1jTlf3YslG95Q1UKcGXLGQSZ5ovc3vVdffLHdc0bemQUCS6Bpk8gD6BtJ/G1
Wry72EGGRfBjVLYogGI0Qls3mdAP7aXMZpn/OQovO4cZC3pUsPGjQHXR/DD6FW1t
onS3zP12zwJXKopRjlFF
=+9Ew
-----END PGP SIGNATURE-----

--Ll0BBk1HBk/f94B0--
