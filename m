Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2LXPf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 10:35:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40057 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXPfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 10:35:55 -0500
Date: Mon, 24 Dec 2012 15:35:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: lrg@ti.com, perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: core: giving WARN when device starting from
 non-off bias with idle_bias_off
Message-ID: <20121224153552.GD30837@opensource.wolfsonmicro.com>
References: <1355913397.17896.10.camel@cliu38-desktop-build>
 <1356085032.1839.14.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <1356085032.1839.14.camel@cliu38-desktop-build>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 21, 2012 at 06:17:12PM +0800, Chuansheng Liu wrote:
>=20
> Just found some cases that some codec drivers set the bias to _STANDBY and
> set idle_bias_off to 1 during probing.
> It will cause unpaired runtime_get_sync/put() issue. Also as Mark suggest=
ed,
> there is no reason to start from _STANDBY bias with idle_bias_off =3D=3D =
1.

Applied, thanks.

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2HZRAAoJELSic+t+oim9/ssP/0mCF43epovtHKA8k2HDkF4B
hanteMzSjU7YtlaQFJSKE21o8qc5lqE6vRe4eAs7+KZFFeR4mY9bPZfOVwP7ggI8
ariVulCucr0KMVD9MX05VmZEMWQnABsQEqNPdpvN1laszifLwG90sfFrA29ZpzFf
BPbWoHXw1f1wDbuFJ0osLqonvZ1Os2qGK8zkJGNGec6/hZ5aYhhOXWcKsTXL5cI0
s6lBzdOqpWxx7/qYjvOZTLUBQxyNY51YI7K2MWA7T+AtLy6NAX6veybPKxNzaJ0a
tdMdzCrrZxGifm0ughptl0akU82hwahtCjSh5t5adWJTPcQAnZKAArX9S9S451p8
hCrrEnhGpxes5Sh9MO/j2Gv+v5z6PY9GkX9CdhdFULdYrCau+TKCf0J+t2G4sfbj
4LRggCGBPehZD6/8ERwj9a3Ih5J4hB1CS5D4kehFE/50qg4fb6RG+ZrGbPUQ0ksA
1IzvcIgWCB/V6rH9NsT8+ZBF7eBmDoDToDxqszP8zDslWaP4a8IJviKac6IRa/kC
jz5mJS9drPWYYfFd9GhyFBUPRl5gnHVuWFJB2qB6ADWD1geLLzhNEe0DIzceMc/d
FdWP+x4sKiHHjGoydlng72b54FW6nbF/sGzpJKVXPqI8zcjR2IMSGiRvfLuWdKky
imAI/5yMU3uBTmWaw6y2
=U59k
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
