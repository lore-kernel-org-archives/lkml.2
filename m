Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab2DDKtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:49:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913Ab2DDKtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:49:52 -0400
Date: Wed, 4 Apr 2012 11:49:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] regulator: Add support for RICOH PMIC RC5T583
 regulator
Message-ID: <20120404104948.GA9693@opensource.wolfsonmicro.com>
References: <1333523640-8820-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <1333523640-8820-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 12:44:00PM +0530, Laxman Dewangan wrote:
> The RC5T583 PMIC from RICOH consists of 4 DCDC and 10
> LDOs. This driver supports the control of different
> regulator output through regulator interface.
> This driver depends on MFD driver of RC5T583 and uses
> mfd rc5t583 apis to communicate to device for accessing
> different device's registers.

Applied, thanks.

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfCc0AAoJEBus8iNuMP3dqHkQAJUTn2b8hmMwYQgRH8o4ko0R
4jt+wzkrFb4vhk7ln2UIOnLhrEn+kUWi5Vm4JdJd/CXOzMjuwfnAPj0D+6i6B0DB
4G4wBBhJgtLrG57ZJZGQ1UUYQMFsDw8bbhPkOja5wHql3oP/ZkCM054QP0QlUJ/R
e6x+8va1Q0d1n46pit0oOsGHbyBhlVzQAJvXxPCMzZ6NZa0rAf7PVAzRYGodg6xi
bInBBIat6w+OiXYmQpaWSo8XTGHnXAj7/ENrAXeABfdcbjieSfr45vOncf/Mw7tB
x0Au0Mpq7KAgfXl2LL0j2Ls4QWVaeM9c1tKq0iDRO41Qx3uZCbisEd/tve0Umid6
HBCvY+6splmygMWEqdxo+ZezLHxYfA8LQ9vIa53te0LUErTsC77K+U1K9YitOOU9
zquTPAp00yGYExY0BVng83/ngMWnLo/gKoFtdavcW7UiTIY8QNcpeVfi2uQJPtfh
e5z25lmjIl6m6pkMeocel6ARLtDYmnaEDAhwY+NbWik+aSozg8kfisZIWtsZtD9j
ZZjJ4/UUe/6/NEN+Qn8ZhrxhfSgdpIjB/TxZXNMCZGekPWAUg6TREm6sSzrSm1Y8
35M11kce8LkWLHlojkGrvOclI+UajFBSXhhHKaRB4IkAQj0WA0h3r0lXFhvRLPnt
la1pB+aY1ACdVTvAdRp0
=vN2D
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
