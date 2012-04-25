Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2DYIYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:24:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60561 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab2DYIYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:24:20 -0400
Date: Wed, 25 Apr 2012 09:24:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl-regulator: Allow CONFIG_TWL4030_ALLOW_UNSUPPORTED to
 be requested.
Message-ID: <20120425082417.GE3195@opensource.wolfsonmicro.com>
References: <20120425122924.0f08f5dc@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Content-Disposition: inline
In-Reply-To: <20120425122924.0f08f5dc@notabene.brown>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 25, 2012 at 12:29:24PM +1000, NeilBrown wrote:
>=20
> twl-regulator.c changes behaviour slightly depending on
>   CONFIG_TWL4030_ALLOW_UNSUPPORTED
> However that config option is not currently listed in any Kconfig
> file.
> So add the option to allow it to be chosen.

Shouldn't this be hidden behind _EXPERIMENTAL and/or enabled by the
board in platform data/device tree?  Kconfig feels like the wrong place
to do this sort of configuration.

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl7RvAAoJEBus8iNuMP3dyTUP/iZXjsEorYalpERjNH0au3uO
OnEpEi0Ufv86EdecYYS8Vv09OUe36V9HPPQiiuLPa4rEsb0YzGEQ3xupxPrzksPR
my9mwllqvna7VFvM7CrWZjZt94wl6y2fci64pKk77VYP95U9Vq49kizhbR7UoSvk
GYUVvNKhU+cTLAa0sHQsHJwv2/OJtL7zAjuuIs3WL4ekPSGfHCGvmHhTpx3FwcLx
Iw/zMP4C5y7RzV7XbDlSA7L3VU/ovCtMSC0beC3jyDnl6e5blXhrUjLs4q7G82wp
Wees3uaMvkYOozNXdxVp6yywXXtedC2DZilrjVjGiBE6He91qNJ8s6UtERsJaX7T
TTIK1SO+dKknEaYo9w1L4aZoDppe+5KwSCBDnR1k79uMMzIQpA7FG9k7eIujUYQY
zC2JRkhR/h3qhhQxZ3i6Bvpr82Q72cpsJBkYbhSWNhbleJo98cTuVfsNriwFzLf3
RhhKwVfxcHWaRB+Pk8bUY/MJUqIg2CX1hyUuX6Qbjdw9NaOG7TGvpih42FTfL7hF
KfjyUlr9BA0gXqXdBEzCDZWFvCFvgV+SgBAxTqJGEXO0Q7FVIv4XDm6e3W4ONOxw
XEJj5oPQgV6xcd+5zebEz650PJ8ssRBjUgGlYy+v1T1Yvoi1/gf8fWZJjF7mqoqv
Ki1ew8CK4svr+LHlrSCI
=uaPy
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
