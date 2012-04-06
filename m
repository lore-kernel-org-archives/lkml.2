Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2DFJSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:18:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36528 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822Ab2DFJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:18:10 -0400
Date: Fri, 6 Apr 2012 10:18:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: fix compilation when !CONFIG_DEBUG_FS
Message-ID: <20120406091805.GG3172@opensource.wolfsonmicro.com>
References: <1333688960-24402-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2NLGdgz3UMHa/lqP"
Content-Disposition: inline
In-Reply-To: <1333688960-24402-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2NLGdgz3UMHa/lqP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 05, 2012 at 11:09:20PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Commit 79c64d5 "regmap: allow regmap instances to be named" changed the
> prototype of regmap_debugfs_init, but didn't update the dummy inline used
> when !CONFIG_DEBUGFS. Fix this.

Applied, thanks.

--2NLGdgz3UMHa/lqP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfrNUAAoJEBus8iNuMP3dnIUP/iL/pwld7iEV1c4/KgY/kdsJ
MjOlZjuxvrSYgx6xV0d4PfXeyJJVSJMFMOGSBGwdz0gSpeoFbNhx2IKJeyARsrXs
Jj+Y1jC7PQi6KKDUSf6zytpeuBPzQPw4+eR2ia44Jk2NutkBoQ2wRRlSn/OLq8Bf
DDU27C02YYZqC5n8oRpee4mfVrPFURs7ZGWEADfcCVeHuDZmH47CgHeGDPor5EG5
JhrY6rLNviq2gl+XXVm9viK4TtFsDGJECwvjeCIw/h6irFtnOzbpJqCUKiBzAv2n
CImIsPHmv/NJ8hvpux1RqGtJ+nf1Z3tOUx9vkTtVfZLYgcCT0NxLZiNQGWQkqD18
aLcAzNB551i6x1NubeurZymtdrpWuxJ1aSx7I4tzi4R6TYSjS8Q8gg1Ho2LxxtbY
FMgnzp0KiIXXgrLBGCwn1H8Nyv9mZA262bph5r5TV0fxzeIw7/KoPKT6bLLKgVKP
hne/9K7K5Crh0jj5B5arbUjufH8hpp72hDgPlZQingEtcbJHsAASmCVbhHZViwby
uI2gq2ZScJzXjHLXoKjbeXAMlmXti0OJSuHDd6TrDvkIiprC/+CBqDoalZDRW+r0
1/jOIOV8yGuy09uTi1+X4f9k8X7QjkZB8l57WyKhqI1FVNA+FSbo0NVCx1QPFE2C
NJiq6ZuJBgue2tlAP6L0
=GeAP
-----END PGP SIGNATURE-----

--2NLGdgz3UMHa/lqP--
