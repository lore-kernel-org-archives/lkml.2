Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2CZRfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:35:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57939 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933145Ab2CZRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:35:50 -0400
Date: Mon, 26 Mar 2012 18:35:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: Fix restoring pmic.dcdcx_hib_mode
 settings in wm8350_dcdc_set_suspend_enable
Message-ID: <20120326173548.GG3789@opensource.wolfsonmicro.com>
References: <1332455105.2948.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NY6JkbSqL3W9mApi"
Content-Disposition: inline
In-Reply-To: <1332455105.2948.1.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NY6JkbSqL3W9mApi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 23, 2012 at 06:25:05AM +0800, Axel Lin wrote:
> What we want is to restore wm8350->pmic.dcdcx_hib_mode settings to
> WM8350_DCDCx_LOW_POWER registers. Current code also clears all other
> bits of WM8350_DCDCx_LOW_POWER registers which is wrong.

Applied both, thanks.

--NY6JkbSqL3W9mApi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKjsAAoJEBus8iNuMP3dpfwP/jiOtMSeAUlwHmA1EkoEZgdm
WUY0m7/g4KnKhBMgDGgsFSb6VdDfwjS5rUWwCGTQJlfEfs0lV3si0aA7h4e9Ej3p
m1fTzayuPvE8uaVRCsRbjUlgiOx0kOYnjURsM77mJykWEBjHrTpLat9kgtNWJDMI
9jPDYIL3rJNla1vOMpoaTSK5J5Q5/HlfbOgLBBSrIqIicl3k0M2sB+0/jDAjFGKl
EoIQI5cYnnqhkjmh/5r9gmCgCVo4BiGeEtTIlqezjx3vakFMcb6pdf+sNFPNr3RB
H/1d0j6XyWFmuNZcDDaq1xmVhWnnfJ7kMfeQTMrK7uZrE/dXQNjwqmfzhJolvjP6
s3y06UW9VXWv9WNUZ1wOUZnHzaBdewEtV8RpWZI+yEYrx1SN+/4/EQJ2l8OXOeP5
QSFErDnKnt6X0/n+AArL8s5JTr0cdMbLh6H/bzs7sybT74L6MV3lXEY6B8NvPz/D
yR+yf4xh4aRXCsMVpKeDzQ2NHYhWvbqe4PpWMY6gMqM6VwmidCMVw3byK3qJH1WL
jeL73j5dpW4Q0gN6NdDgAP7nkM81Kc23z/1mnA1R3L7A54m7V/qM3YYHi4NcFcoB
CRks7Wjk6B4Qe8J4aaz/Tgy7SdpMBpos4VEoMzSVMRf/nnxD/WbGFKfLbE0yeXGJ
glVH40ne8/ApJcRGXZ0n
=usf7
-----END PGP SIGNATURE-----

--NY6JkbSqL3W9mApi--
