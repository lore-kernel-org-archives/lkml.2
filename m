Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2KOFhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 00:37:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48222 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab2KOFhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 00:37:04 -0500
Date: Thu, 15 Nov 2012 14:36:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        g.liakhovetski@gmx.de
Subject: Re: [PATCH 2/2] regulator: tps80031: add prefix TPS80031 on common
 defines.
Message-ID: <20121115053648.GH7599@opensource.wolfsonmicro.com>
References: <1352907569-12466-1-git-send-email-ldewangan@nvidia.com>
 <1352907569-12466-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJWb33pM2TcUAXIl"
Content-Disposition: inline
In-Reply-To: <1352907569-12466-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJWb33pM2TcUAXIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 09:09:29PM +0530, Laxman Dewangan wrote:
> Pefix "TPS80031" is added on all defines of tps80031 header
> to avoid conflict with other header definitions.
> Update the regualtor driver of tps80031 to use the same name.

Appiled, thanks.

--uJWb33pM2TcUAXIl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpH8+AAoJELSic+t+oim9ofgP/3JMTyISDWAxqptEjcHfs1AH
a5TReifrKw6jrBCDyG5XDk0YnSMAIdDuHp8wqqMpyj1FU/AjBTImqga++9zrbL4f
dKFBIk4q/Fce6nGCn4xrrWSMjbDaDGzBB7e2mx/+ftJIqiXBjyHhVjg3KKRRVgPp
rUFeCmFjo7p2z1NzWPL2UQZD+dXAHKkvVm34QRtfW2CMDJ+p7tdbIyKUUYwBHVFs
BUcbCa8iZgV8qfwVrf6HyLrOxpZSZ3pj9Mx6Oohlv3RUvZGd3quuU9veGTMT3N0M
e15rrrjBYcLnKKmwHzA0U5Pd0QywlcRXIUINNuJLf5Mxcok9gRr5CT1ZOUofE89H
5iJwvcTJ7qrhxtRwM34WVyiwJlEW7buoN24iuvfBPA/03spBAGduEfDmkwDFCu2o
O6RkfgYDPYCxR2gg7g64bkijbt00Vf/rAVb4Qlustf6JPITt5Fg/qx26/fkuKK/V
jSvYy28za4Xj2kWbKv5Lptd5rgkfxVhY+NxBHiTYjSQnM6wA1BbeYzlrwtUeeeRk
bIiMPPKQen/RVflcUs8g5VqeQoQa57ROJ9nAMrl04zPFS6rT3zaOTGaj4ercHUjj
3frT7XVPzIbHM9NL+7YqA1phriqgxnow1NXVRzSyqyvlbRnuPKG1tF6Ti8Su8qC3
hpfXWLqRfB7g8CxkPb1a
=/iqi
-----END PGP SIGNATURE-----

--uJWb33pM2TcUAXIl--
