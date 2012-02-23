Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2BWSzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:55:08 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44690 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752418Ab2BWSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:55:07 -0500
Date: Thu, 23 Feb 2012 10:55:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: i915 regression with 3.3-rc3+git
Message-ID: <20120223105500.59e2476b@jbarnes-desktop>
In-Reply-To: <4F468A1B.9080408@gmail.com>
References: <4F3EBD0D.7000906@gmail.com>
	<20120223084106.4b132532@jbarnes-desktop>
	<4F468A1B.9080408@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NwPgiR8JoVYW6/ek=y0MrJX"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NwPgiR8JoVYW6/ek=y0MrJX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 19:48:59 +0100
Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:

> Hello,
>=20
> Il 23/02/2012 17:41, Jesse Barnes ha scritto:
> > On Fri, 17 Feb 2012 21:48:13 +0100
> > Riccardo Magliocchetti<riccardo.magliocchetti@gmail.com>  wrote:
> >
> >> Hello,
> >>
> >> i've upgraded from 3.2.0-rc7 to post 3.3.0-rc3 git
> >> 4903062b5485f0e2c286a23b44c9b59d9b017d53, attached you can find dmesg
> >> with drm.debug=3D0xfff
> >>
> >> This started to appear in logs:
> >>
> >> [drm:intel_framebuffer_init] *ERROR* unsupported pixel format
> >>
> >> X is getting a wrong resolution (log attached) and there's a lot of
> >> flickering, if i try to play a video the desktop turns black, the other
> >> ttys still works fine though.
> >>
> >>
> >
> > Can you check the drm-intel-fixes branch at
> > git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/drm-intel.git?
> > It has a fix for laod detection that might help.
>=20
> 3.3-rc4 plus these two patches from drm-intel-fixes works great.
>=20
> 4e9bb47bd29e02f2daaa7bdb2a8ddf977bf76f06 [PATCH 2/2] drm/i915: fix a=20
> sprite watermark computation to avoid divide by zero if xpos<0
> 5ca0c34ae28344b6b4ca3036bc82f89c8db16a59 [PATCH 1/2] drm/i915: fix mode=20
> set on load pipe. (v2)

Great, thanks for confirming.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/NwPgiR8JoVYW6/ek=y0MrJX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRouEAAoJEIEoDkX4Qk9hDS0P+wY9DsrkYNBtj4uvDiXbbOyX
N3vIVx4DdYvHtnlmy1RBnFN7zlbCO5RvaNkyD4Z3GH3HcuMi8VHNSdmEVuP1pRx6
cfQRHWZe5xspnCe84yyr+onZ1GHHbaP6E84b+saJeEsKxq4D3B4NfQnn1OGf7IwO
dZ9lsX16oNGCBKSO5z8Z9Lhh5f/mf1hcPpoCQMRpfGmvLP7dtEzYKdxJbJ3uVatj
7TkuaUU0E//Wedmyk8Y6lGT4WmAtrkdilmaIuBcu65mPYFGE1j0p7RQTS3ZVDuGh
ncBrSRqWd/DyqWnN8WX8cQzvTObkKUDiAr4KZp5Zbsv19nIen6vQReQ783ZGHvRE
eM2OGYF8oYt+L7anAG5yxNNjJYXhlZQkaSCVWQJHVYJBv0FdpAcfzxTvVxz6qDYR
oP3cKUVZ+yk/9rT7gxu0+2dTmzQvO3TDdVd/IQ+4RmLSUkJrUEUsUX1a7j1og+tq
DpoLSOJVaDLAYoD48oT+hKfAIZF7uxqxTQe8nlmm4LePLwCYjEb9OxRKJmEcK/P1
W39HsJ2eP6V4UTuii6HRo/WrEQKacxvFu98kbE2ebbnYD5kzQxk4pEyV/0ddimfE
0MfGh+00fLBS6fB2DAdraGuT7XLCKhiNaI3OXG5Zhkx0bIlxQwSZG6M0/BrogsvK
6rAqI8Ux+gD93Vd0fwqc
=gLAP
-----END PGP SIGNATURE-----

--Sig_/NwPgiR8JoVYW6/ek=y0MrJX--
