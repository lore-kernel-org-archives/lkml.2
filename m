Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2FSMSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:18:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42278 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab2FSMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:18:22 -0400
Date: Tue, 19 Jun 2012 13:18:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: support for regulator match by
 regulator-compatible
Message-ID: <20120619121819.GN3974@opensource.wolfsonmicro.com>
References: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com>
 <1340085087-6608-2-git-send-email-ldewangan@nvidia.com>
 <20120619093211.GB3974@opensource.wolfsonmicro.com>
 <4FE04788.5040008@nvidia.com>
 <20120619104254.GD3974@opensource.wolfsonmicro.com>
 <4FE06B31.3050306@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y8OL7jWO5wDKNv+B"
Content-Disposition: inline
In-Reply-To: <4FE06B31.3050306@nvidia.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y8OL7jWO5wDKNv+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 05:36:09PM +0530, Laxman Dewangan wrote:

> Just thinking on optimizing the changes require, we can do it in 3
> patches only:
> - In place of adding new api of_regulator_match_by_compatible(), we
> can modify the existing of_regulator_match() itself  to look for
> regulator-compatible for matching. This can be done in first patch.
> - Need not to change the .c files, here just change the
> documentation of these regulator dt binding. All can be done in
> second patch.
> - Change the dts file to have this policy and seeing only on
> arm/boot/dts/db8500.dtsi for ab8500 and db8500-prcmu. So it will be
> third patch .

This seems fine.

--y8OL7jWO5wDKNv+B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4G4BAAoJEBus8iNuMP3di2wP+gPcdiSrsEOgBmlO11CRoSFP
biciYMTZuoeoF6gOowT1IJmXUdVZVfOC2KcD8q2+pnzi42arSReSkVzuEHGpHQ4s
Csntb2nyX1gjrnGAGiePvZ31RNKRJ9zS7o8f65ENcq8asXIMCW8GFjtINutmJKl9
OADjZunggXabDDbNHqyQwLA5LS5p/P2h6OlCXi4eYyQSliLot2eNv8TE3gN7QOeh
FtfKhNqvKVmIyU6GUtOnDp+22GLiDY8PKMowzfJuBapzV5XezxchsI0fPkIPxXwN
/50qMz83m5yjSVWTmNTVu4MIBBwXfkjyar7ztd3zDgfxrL/bejp+FaTmbcCOfIOq
ofOVLtSbcvDaFzwmde6vQjH2ORy/9zpfYn8rHM32UiFC+h8O3s9+PdvEzHo0atPP
Bu2T2IfOcgo5pZlsyl2FHsTnvPb/Ce94ob/nx9wjWJmneQffdTGqNfA/FWhC6tq7
Txc5zUj4o2ycb77zFHaL8hY6f1Dh1ZZyIzpyFzmuRDY7qu2/NOXxRA3jH423xF+b
Vm+TqmWfmNxgXAxyrw6Ul0abXXNXXeTWUO2HTayOOyGSa6CG48INYpceSF4Xv3jy
R77hMsu6lFa3/I+wSKkDdm64P4hUtACMXAqkEmhWjiU5bfrAQvvkJbBO35+pavGX
SZNLDyuMoQliV6AnFmwy
=hDCx
-----END PGP SIGNATURE-----

--y8OL7jWO5wDKNv+B--
