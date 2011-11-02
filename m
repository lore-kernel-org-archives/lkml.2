Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1KBT0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:26:35 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:49682 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab1KBT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:26:32 -0400
Date: Wed, 2 Nov 2011 21:26:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Gary King <gking@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/tegra: add support for tegra30 interrupts
Message-ID: <20111102192625.GD14372@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A46E5@HQMAIL01.nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A4758@HQMAIL01.nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A47A7@HQMAIL01.nvidia.com>
 <20111102192112.GC12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <20111102192112.GC12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Wed, Nov 02, 2011 at 07:21:12PM +0000, Russell King - ARM Linux wrote:
> On Wed, Nov 02, 2011 at 12:09:36PM -0700, Stephen Warren wrote:
> > To solve this, I recommend definining ARCH_NR_GPIOs for Tegra, to somet=
hing
> > large; I see that arch/arm/mach-shmobile defines it to 1024. Failing any
> > disadvantage of using a number that large, I'd go for that...
>=20
> I'd suggest that we immediately start solving the ARCH_NR_GPIO
> definition a single zImage friendly way - rather than throwing a
> definition into mach/gpio.h, add this into asm/gpio.h:
>=20
> #if CONFIG_ARCH_NR_GPIO > 0
> #define ARCH_NR_GPIO CONFIG_ARCH_NR_GPIO
> #endif
>=20
> and in arch/arm/Kconfig:
>=20
> config ARCH_NR_GPIO
> 	int
> 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
> 	... etc ...
> 	default 0
>=20
> The list should be sorted in numeric order, largest first.
>=20
> This then gives us a path to eliminate the ARCH_NR_GPIO definitions
> from mach/gpio.h - and should allow more mach/gpio.h to become empty.

would it be better to just change the default value in
arm-generic/gpio.h to something very large ?

I mean, ideally that wouldn't be gpio_desc wouldn't be an array anyway
right ?

--=20
balbi

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBAgAGBQJOsZlhAAoJEIaOsuA1yqRE/qEP9jFVgYAbTmL6IJpIBBqj2kCx
qGNrnSlrJcrlE/4Zfl+QhmqbCu9Oeqy9YWB/MFlSLIQRBvmKzw37g+7VGd4/g73e
LW8thmHrugYjmKPKeCRaSQ/wio5PhHF7Ry+r6w4NcNT5ozJRaJL9ozVoKIKU1VIj
zCih8OqSGz/JK4+e3H4S5BldD1+eotmQT3s+CcdfIx2NEsxRuNzYo/7v8eRRWPQd
PE//593PV4tC/iOSgKBI6vyBuPB77OuUZcR6OEb+xZFMV2IBi0hFMANFoBuAm6L3
zT3fsWfS7M5JU7dbjjQNiLrRJSxFSLcIgd0MOvNgcvRNvu1GqT/7ij8rLDDVxy7O
VgGwhXJI55eDCndvJ/CmAIOXHWhh6kfXfES5uQo0RlDBAW1LU6PvsExLqW7VRDYc
qmojyBxAzIXZ6GIHNRu40dRWAMVrbAsS5BF+JcTFkaGrjdGn9OhGKJ/tOnyNcyWl
qjYcAPBWBEl5MZqwWZ773DdQUqN8fpv5Q5HZvQ5gCrpqnhXs4ciUkICDbSTQkVZg
CW+Yk6w4CR7RVnBCGGffJf1jFRZZfFLQ1C8t1hdzn10+O4Zd1PELNAkyACI+tamJ
rL35G77UtkqmBmG3nGSM375FNdaifkdYXc9uz3OXDxcReXXTwPS+sRIEOfpM3dsj
EBSHFDRKqwG/6sFU1IY=
=Kb7I
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
