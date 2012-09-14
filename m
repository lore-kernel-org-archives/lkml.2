Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab2INIYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:24:24 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:56290 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758532Ab2INIYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:24:19 -0400
Date: Fri, 14 Sep 2012 11:19:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: davi@gnu.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: ARM Development Platform
Message-ID: <20120914081940.GB19665@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <201209140855.29737.davi@gnu.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <201209140855.29737.davi@gnu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 14, 2012 at 08:55:29AM +0100, davi@gnu.org wrote:
> To get used to develop for ARM, do you think I should focus on Linux kern=
el=20
> development or on Android project development?

it really depends on what you actually wanna do. These days there are
many, as Linus once said, "throw-away cheap" ARM boards out there. Check
out BeagleBoard XM, PandaBoard, BeagleBone and Raspberry Pi to name a
few.

> Would a Cortex-A* chip be valid as development platform?  If so I will buy

Cortex-A is the newest "family" of ARM Cores (if you can call it that).
Cortex-A15 being the newest one and Cortex-A8 being the lowest end.

All you have to do is choose a board, choose what you actually want to
hack on, and start hacking.

cheers

--=20
balbi

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUuicAAoJEIaOsuA1yqREOcMP/1t2rBAv+enZydOJC/Y9p4a3
lp9W9/ednXfVLI3UIugWgoVJg1Cgqtx5qJ0kUdJ7DYsT9Wb27WEjWaaxRWSQdgma
SW0mj1xd8DRNTDcuSB8LMB1FyVLE+r/4bsm5mnDItJp0HM5pmFhpSe8SXbHtvCOn
TSSZyhPgpORBLpJ4yjMgWvheBRSj8vjsLwKo3MS7n/ekt4N4MR8CBxVyPivonOLo
7FycG47Zod5Voz1Rvbd6xhbhS89LXf4jagRhA4bnfcIIAIKfeiD+Ls1IEBxu1dtD
j5kqJxv7q2xc60MP1n4pegE4+C9/UVkXjCzXmseNuKeV0Tq8GXpXLCDvY4lfKf7+
MoIWwT4EBsHRVehlALX9jujk0qCmdMxsAPFE0Np5s4/W2Pbs1b+duhV9h+XnkQL2
L8pIT1bq0V8/6YTsB9yKKuVF9ho2BTfxYOlsM/5Sf/pI58N7zx+BHlpkY50m0ym0
IMJPFwGz33mVt/eo9ZRMKfbJ6XeX4k2L9lU1GyctlccRq9ZzSVVyQjuBYYa3VIxl
uEUidGRy4iBO4UpAyRBR3QFLiV0NtE5TrcQX/QzAjsdn648FUPtZSCftubOy8Arj
gC2a9QJaFAAvLvjiQV/8/ub1PD1dl6DVKr4V/ahyxwiZM4URw8tOkTPT7x2iywsv
fejKPTEYIwdLrMO1XryZ
=pjTl
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
