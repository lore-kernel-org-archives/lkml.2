Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2ESQxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 12:53:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34956 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab2ESQxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 12:53:31 -0400
Date: Sat, 19 May 2012 17:53:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: linux-next: Tree for May 16 (mfd/tpx6586x)
Message-ID: <20120519165327.GU4039@opensource.wolfsonmicro.com>
References: <20120516201426.3a162ecd6adeb7132413f1b9@canb.auug.org.au>
 <4FB3D2C3.3030507@xenotime.net>
 <20120519142506.GN12015@sortiz-mobl>
 <4FB7C310.3010403@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aQ0PHH3iiKbaMI5N"
Content-Disposition: inline
In-Reply-To: <4FB7C310.3010403@xenotime.net>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aQ0PHH3iiKbaMI5N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 08:58:08AM -0700, Randy Dunlap wrote:
> On 05/19/2012 07:25 AM, Samuel Ortiz wrote:
> > On Wed, May 16, 2012 at 09:16:03AM -0700, Randy Dunlap wrote:
> >> On 05/16/2012 03:14 AM, Stephen Rothwell wrote:

> >> drivers/built-in.o: In function `tps6586x_i2c_probe':
> >> tps6586x.c:(.devinit.text+0x144e0): undefined reference to `of_regulator_match'

> > Is this one fixed now ? It's coming from Mark's regulator tree, not the MFD
> > one.

> It still fails in linux-next of 20120518.

Probably because the selection of people mailed is rather random - not
only is this the first I've heard about this nobody who actually works
on the driver was contacted either...  I don't know how the recipient
list was picked but I'd suggest including a look at the git history
might be in order.

--aQ0PHH3iiKbaMI5N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt8/9AAoJEBus8iNuMP3dKRkP/A+sDSRs4RIbiiFwHReJSBPu
SVHiIGL5R4qV4WOLrY8bmQ/ko/yO1BDKRKhbEFJX1kUhtZjCiIX+zzGC9DLMYb4r
cTOrajOIVdRnyZTvP9x7ZCyfmHDr3e7saB9pQmu3dBt6f01yzMMusUdqN1dgHgHU
DcLn3RSG6/tELbbO/Rtjck9u+ygztTxoKWIdAPTcFgR7pNTfFPqrUSWxixPUR1Jn
twTLeuVmpjOt5ruexwHe2w2St2sEgmBuWapZK5/3/Itri3xZ1knp3F608Ee7H8Xj
C0r4bt6pZajXoP72ioz/7mjaVnND15lCg5gpr4zb4ibyK7j0MfIQxwIzgo9+zK8z
C3mHi0NaeEhyebAnxD3oBc9L1DaNz6zZ0nbrKSMFWZMaq9n/Ar5fSaifKdDUlhES
0QLrQ6qsdn+WuXJhwU6Shod/Gbtmia4rvMAK0BvDoBZh4GKfU26bj1WPCtR+7HWf
cjyfYKIkMBACtPCkEkWb+8wri5h3QWKxGMqt1tE4IBrgI9t/vx/P5kbI/4HASrkn
8L2f6DxktHGtvZV3L1CUGWRJo9/V51fLpD9LgF1msrfG704o1PcBguqEow5NMm+L
Vz81hiJzxMjZzobqAMZFvGTXKMjJQbD4VNsFlqddC+imLBYd7qya41pxYXtJotoO
aLzJ753SaLJYI2j2w0hE
=Ph8z
-----END PGP SIGNATURE-----

--aQ0PHH3iiKbaMI5N--
