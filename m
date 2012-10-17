Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab2JQNVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:21:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39696 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689Ab2JQNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:21:23 -0400
Date: Wed, 17 Oct 2012 22:21:17 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, sameo@linux.intel.com, vbyravarasu@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/4] regulator: tps65090: fix regulator registration
 and add external control support
Message-ID: <20121017132115.GR14199@opensource.wolfsonmicro.com>
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QxN5xOWGsmh5a4wb"
Content-Disposition: inline
In-Reply-To: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QxN5xOWGsmh5a4wb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 09, 2012 at 03:18:58PM +0530, Laxman Dewangan wrote:
> This patch series fixes the regulator registration issue and add support
> for external control.
> Patch 1: It renames the driver name and regulators to more appropriate.
> Patch 2: Fix the issue with regulator registration.
> Patch 3: Add LDO support.
> Patch 4: Add voltage output level information.
> Patch 5: Add support for extenal control for DCDC.

Applied all four patches, thanks.

--QxN5xOWGsmh5a4wb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfrDCAAoJELSic+t+oim9ax8P/Rvyc5nxfNw4SouMs+marAzP
46h7lRbJSlklcz4ePsD1dQHcSsJoVfAXFqqOVUbSfyP+fljUv4p5TvL9vSeHncpY
qcVp8mbwWtvSNwyLXNgctzGfZyVkmJTYOe9QfpzQ65HABdghrA5jorBzZ1+qhESD
a5AbLS3YQ3oiByasYfnjiQ6tgxh3sJJ7JMHgroKO3LjLuLn3FNvm1DIK1AcVPm5t
e4xCxePfhHggzfHRTT9GKFDDz225U9cVMI3p23x8B6OxfHuOMA5j+YnLC9q81FKS
r2WkGn6gaS+SRGj6MuEbl5QDcTjdHfUYSKQLI/sGUwiIVzd8h8Il7vWQz9WXlcUc
gQXkaUU4w1v1fnD/ee1GnSr996xbx07RLf2DEBKvrHakguKuXwcN5uuw9eUM29Tf
ngefb0V8tSnwbRADTHEEL4cEN0cEsEZRxNJCvx2LlSBQD5zGTuZlS0rdbkI4Kwmx
CUuPTD7lgafZB+n+/gklFPfUPXlBtsbqdGxXZ6gEt3bML4QVIryW4DnApENXvPl4
T+30ZOehmZ/RPPECHMFyspCDM4T6i6F0EO2N9ktet0eh2N2wPxYDfFXo464y1NSI
jqvlGNof5+AIVC2d7OFlAYMQoa3bN0NRVg2KeJ5OnwM7OIuEzYyvpk9a/wqylj5c
vqADVmMTxkSTsYqg4dNg
=2RDo
-----END PGP SIGNATURE-----

--QxN5xOWGsmh5a4wb--
