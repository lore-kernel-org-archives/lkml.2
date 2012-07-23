Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2GWV3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:29:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38412 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab2GWV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:29:19 -0400
Date: Mon, 23 Jul 2012 22:29:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, ccross@android.com, olof@lixom.net,
        lrg@ti.com, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
Message-ID: <20120723212916.GE12438@opensource.wolfsonmicro.com>
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com>
 <1342187432-18668-3-git-send-email-ldewangan@nvidia.com>
 <500DB960.6020802@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Content-Disposition: inline
In-Reply-To: <500DB960.6020802@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 23, 2012 at 02:51:44PM -0600, Stephen Warren wrote:
> On 07/13/2012 07:50 AM, Laxman Dewangan wrote:

> > -	config.dev = &pdev->dev;
> > +	config.dev = pdev->dev.parent;

> Those seem like unrelated changes, but I suppose it's fine.

Not entirely, it's being done so that the supplies are on the I2C device
node rather than on the synthetic node that we generated to instantiate
the regulator driver from our MFD.

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQDcIgAAoJEBus8iNuMP3dfZkP/RQl+079xwMfPn9z3Nfr+UHA
bCy58eZqxkEgCaN7casCV/W3cWA9kRW1n7KTxbUDf7brzBcKB1ERF6Xt7Xo/MsCX
PqA6mmzk49m8YMsyyn5itQkhxgqYZzTNexh54VeMBbCxtFaE5dOJruMuxuA7e/WD
m//HDkkV//xQfiPMjoYpiHfs9qj7wp+t1b92g2mhjFXECksVFAV9HfyBD1s2pR62
PPIQD6nmfEqNyuhyNjNZLL/g+7mpvPKum4Cw8lIaAwKtvcX0mKRWOMUfT7yCYlWt
hW5JPETtq8Uufrz4rbnKMGX3IBIG/UgoNrbcPBTvAFGNQZlEEWAYxIQBq0IfTWnO
gOBRN27FobPJlinaiOQOXf8O7d7VZEYrVoEzSrpKfvhHVTzspEXe0gxGiZf8yda0
8oZPmyjdlioZ5Y3pLZWM8JDvMwncKsp6/heGdo76YU+UIzoMEdWWupA/Oq0TOau+
kL2nDfpsf4Auh/qL4P/ExE0uC6ztlYWiKLFlhYuURjlnSCZcC8aJLHyUvqUn+/Z1
OW90yo3Q6O3ziYwgzn955mqlJhkIAjBvjXFzFYfTp8sF0qA6JYrafLjhBdxUzw3Q
Hm6jG8E8ecXd34rhYjPVcfe67l20q4uk3ThGfXGEOPsN8LWPUsDDYXNLSRcKy/kn
zTRrKUh9YRACKgp16FYH
=fF/G
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
