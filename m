Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1CFTU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 14:20:27 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33438 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1CFTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 14:20:26 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Sun, 6 Mar 2011 20:20:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-snapshot-p1+2-00163-gfb62c00-dirty; KDE/4.5.3; i686; ; )
Cc: Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
References: <201103051510.35057.Martin@lichtvoll.de> <AANLkTi=3HwdHdQzoLUDebfAAMKwSQvVZ43_eQDfi1iB+@mail.gmail.com> <201103061929.23007.Martin@lichtvoll.de> (sfid-20110306_201642_083183_B31E4C02)
In-Reply-To: <201103061929.23007.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3120162.bKJLf5Ju2x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103062020.21959.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3120162.bKJLf5Ju2x
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Sunday 06 March 2011 schrieb Martin Steigerwald:
> Am Sunday 06 March 2011 schrieb Alex Deucher:
> > On Sat, Mar 5, 2011 at 9:10 AM, Martin Steigerwald
> > <Martin@lichtvoll.de>
>=20
> wrote:
> > > I will add a regression entry in bugzilla after I got the URL of
> > > that mail.
> > >=20
> > >=20
> > > Hi!
> > >=20
> > > No, I do not actively search for lockup bugs, but they seem to
> > > search me ;).
> > >=20
> > >=20
> > > martin@shambhala:~> cat /proc/version
> > > Linux version 2.6.38-rc7-tp42-00142-g212e349 (martin@shambhala)
> > > (gcc version 4.4.5 (Debian 4.4.5-11) ) #4 PREEMPT Sat Mar 5
> > > 12:03:41 CET 2011
> > >=20
> > > locks up hard when using desktop cube of kwin from KDE 4.5.1.
> > >=20
> > > It happens within a few seconds to about 30 seconds after
> > > activating the effect with Ctrl-F11. Otherwise the machine seems
> > > to work fine so far - if that continues I do not have much of a
> > > problem with the bug since I do not use desktop cube other than
> > > for getting a feel of compositing performance. Effects seem to be
> > > more fluent, more smooth anyway, I guess due to Radeon KMS page
> > > flipping.
> > >=20
> > > I am using X.org 1.9.4 with Radeon driver 1:6.14.0-1 on Debian
> > > Wheezy/Sid/Experimental on a ThinkPad T42 with:
> > >=20
> > > martin@shambhala:~> lspci -nn | grep VGA
> > > 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc
> > > RV350 [Mobility Radeon 9600 M10] [1002:4e50]
> > >=20
> > > This didn't happen with 2.6.37-tp42-rtime-00004-g9eb63ce, same gcc.
> >=20
> > Did you also update your ddx or mesa during this period?  It might
> > also be a issue in the userspace acceleration drivers.  Are you using
> > the r300 classic or r300 gallium 3D driver?
>=20
> Debian maintainers activated the gallium one in the meantime:
>=20
> martin@shambhala:~> glxinfo | grep OpenGL
> OpenGL vendor string: X.Org R300 Project
> OpenGL renderer string: Gallium 0.4 on ATI RV350
> OpenGL version string: 2.1 Mesa 7.10
> OpenGL shading language version string: 1.20
> OpenGL extensions:
>=20
> I think I tried the desktop cube with the gallium one already, but I am
> not absolutely sure.
>=20
> I have a 2.6.37 kernel still at hand and will test with just changing
> the kernel.

I verified this. Lockup happens with 2.6.38, last one tested rc8-gfb62c00,=
=20
but not with 2.6.37 with exactly same userspace. Needed to try the effect=20
several times, as this time the lockup with 2.6.38 only happened shortly=20
after the second activation of the effect.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3120162.bKJLf5Ju2x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1z3mkACgkQmRvqrKWZhMcPkwCgqRhrRQljb4yCZwSIp6VgkHmm
eYgAnjdmJtP9p6I18dl7DYwqWw98zBZd
=5qd+
-----END PGP SIGNATURE-----

--nextPart3120162.bKJLf5Ju2x--
