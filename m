Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2BWQlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:41:15 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51808 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752207Ab2BWQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:41:14 -0500
Date: Thu, 23 Feb 2012 08:41:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: i915 regression with 3.3-rc3+git
Message-ID: <20120223084106.4b132532@jbarnes-desktop>
In-Reply-To: <4F3EBD0D.7000906@gmail.com>
References: <4F3EBD0D.7000906@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MAZAxcxpjNWTpsyO4HX_kTQ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MAZAxcxpjNWTpsyO4HX_kTQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Feb 2012 21:48:13 +0100
Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:

> Hello,
>=20
> i've upgraded from 3.2.0-rc7 to post 3.3.0-rc3 git=20
> 4903062b5485f0e2c286a23b44c9b59d9b017d53, attached you can find dmesg=20
> with drm.debug=3D0xfff
>=20
> This started to appear in logs:
>=20
> [drm:intel_framebuffer_init] *ERROR* unsupported pixel format
>=20
> X is getting a wrong resolution (log attached) and there's a lot of=20
> flickering, if i try to play a video the desktop turns black, the other=20
> ttys still works fine though.
>=20
> Please CC me since i'm not subscribed.
>=20
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series=20
> Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA=20
> controller])
> 	Subsystem: Samsung Electronics Co Ltd Device c045
> 	Flags: bus master, fast devsel, latency 0, IRQ 45
> 	Memory at f8000000 (64-bit, non-prefetchable) [size=3D4M]
> 	Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
> 	I/O ports at 1800 [size=3D8]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
> 	Capabilities: [d0] Power Management version 3
> 	Kernel driver in use: i915
>=20
> 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset=20
> Integrated Graphics Controller (rev 07)
> 	Subsystem: Samsung Electronics Co Ltd Device c045
> 	Flags: bus master, fast devsel, latency 0
> 	Memory at f8400000 (64-bit, non-prefetchable) [size=3D1M]
> 	Capabilities: [d0] Power Management version 3
>=20
> Thanks
>=20

Can you check the drm-intel-fixes branch at
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/drm-intel.git?
It has a fix for laod detection that might help.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/MAZAxcxpjNWTpsyO4HX_kTQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRmwiAAoJEIEoDkX4Qk9h+8UQALF0aZMvXXzqC3t9yavzmvI0
F/8NEv3cfksteomp/L73dE0QO5XgItJ9t98B/2J2utpkQUsSv+1GnrU/nKorje5a
qmRWIGjPTqimRUte2TBcFGmIW7rp1SM9oGaEye2LwUw0mvWk0sSNwxfJUKbFxYvH
4d8Ez5aanSnH6g1OCCORqGIQKF5D/7xHSZMhcTteVRI1gS9MpT3Udxi6DS8JzuFk
XsSrG8z768MqNcUdPTQX0J/no1l1EoSJftaFeRtLA6P0dVwljqLeOO53XYTTQ9eC
gUsWawzN0JGEJoPOvYe3AYmSLW7YY6sGAY9qVWiBwJ9652mTdF+BMM4oLFsj4BZe
17immOiSX0yrQWpqDbFdKkuAyuBVhzIN9UvwfVt6LDOqA02W420756SXZs60Kdwo
YL5+Qsy8CEkiEIbRrU192q2zv2Y7sElgH1ZYAoirQXM11nxQVlyXaHzMHwhikYPE
qH8dy2qGgv4wnh8OHJwhaNPKlUuz8rukmjSYNJ04gfMVgslwcr+w4mEDq/3/Wpwy
aM15uPHrkZeaBj7LkU+AtB3+Y7jFVIhvpXfSX83YqHkv/pRXwJcyOpvhpKt3aebl
jinRINqhS0kRBFu2BijUa/ecDeXyfY4XMqwVjcHOxw+QrSkWY1BBfoDyR3sCQ+Dz
g9E1MOzGlvB9QZ6xqIds
=ZoJN
-----END PGP SIGNATURE-----

--Sig_/MAZAxcxpjNWTpsyO4HX_kTQ--
