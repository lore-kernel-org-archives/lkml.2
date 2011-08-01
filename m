Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1HABFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:05:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49820 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab1HABFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:05:16 -0400
Date: Mon, 1 Aug 2011 11:05:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH -next] regulator: aat2870-regulator.c needs module.h
Message-Id: <20110801110507.7ca032b85a285d1f9e755146@canb.auug.org.au>
In-Reply-To: <20110801103304.e77887ff2e60f4f6d5c9f91f@canb.auug.org.au>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729211309.92e8b744.rdunlap@xenotime.net>
	<20110801001523.GA20641@opensource.wolfsonmicro.com>
	<20110801103304.e77887ff2e60f4f6d5c9f91f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Aug_2011_11_05_07_+1000_nzFg9X2e_e+xccgn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Aug_2011_11_05_07_+1000_nzFg9X2e_e+xccgn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Aug 2011 10:33:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 1 Aug 2011 01:15:24 +0100 Mark Brown <broonie@opensource.wolfsonm=
icro.com> wrote:
> >
> > On Fri, Jul 29, 2011 at 09:13:09PM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <rdunlap@xenotime.net>
> > >=20
> > > aat2870-regulator.c needs to include linux/module.h to fix multiple
> > > build errors.
> >=20
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >=20
> > but if the breakage isn't in mainline yet to minimize the breaks
> > bisection someone should figure out which tree introduced the change
> > with module.h and either get the fix merged along with that.  If neither
> > the module.h change nor the driver is in Linus' tree yet I rather
> > suspect this should go via MFD as I seem to recall that the driver is
> > going in via there.
>=20
> It is indeed.  I have this patch set to apply to my tree today after the
> mfd tree.  Hopefully Samuel will put it in his tree for tomorrow (and
> before he asks Linus to pull.

Too late :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Aug_2011_11_05_07_+1000_nzFg9X2e_e+xccgn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJONfvDAAoJEDMEi1NhKgbs3TwH/j8QfIcXDG649iv2CDb1KqXr
+Y/9KZARhv/BU1NuCs1C0o3lS9piSOhytg0M/Aepfu6HK/zGV2uXM0IJoz8eFNqA
BWpxxSDyS7xtv+XYhDJ3mU4935Y82+RZXZ9cq13xWVrLBVo+OmBkEqT9fDq9Co4G
REFo8Kuc9lYUZdl2xPLvliyKT1eArICLW+oHOdHx3FN/kosx/lZbjsVwYW1NP3YH
uyLN7dIp+0V08O8XHEMjjrLtKlzybn0QdKDCEexJmKpICpw73QfLHTD4ETPtTSrW
qCvOJ0cKx0i+plCRWcroeRfqDC1hs1zmw1f4SXTkW3g8uk3YUPWxhVVa0zJCMOk=
=R+rT
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Aug_2011_11_05_07_+1000_nzFg9X2e_e+xccgn--
