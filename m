Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HAAdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:33:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53370 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1HAAdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:33:12 -0400
Date: Mon, 1 Aug 2011 10:33:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH -next] regulator: aat2870-regulator.c needs module.h
Message-Id: <20110801103304.e77887ff2e60f4f6d5c9f91f@canb.auug.org.au>
In-Reply-To: <20110801001523.GA20641@opensource.wolfsonmicro.com>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729211309.92e8b744.rdunlap@xenotime.net>
	<20110801001523.GA20641@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Aug_2011_10_33_04_+1000_r6ADTF2JzFGey.07"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Aug_2011_10_33_04_+1000_r6ADTF2JzFGey.07
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Aug 2011 01:15:24 +0100 Mark Brown <broonie@opensource.wolfsonmic=
ro.com> wrote:
>
> On Fri, Jul 29, 2011 at 09:13:09PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >=20
> > aat2870-regulator.c needs to include linux/module.h to fix multiple
> > build errors.
>=20
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> but if the breakage isn't in mainline yet to minimize the breaks
> bisection someone should figure out which tree introduced the change
> with module.h and either get the fix merged along with that.  If neither
> the module.h change nor the driver is in Linus' tree yet I rather
> suspect this should go via MFD as I seem to recall that the driver is
> going in via there.

It is indeed.  I have this patch set to apply to my tree today after the
mfd tree.  Hopefully Samuel will put it in his tree for tomorrow (and
before he asks Linus to pull.

> It's not entirely clear to me why this started showing up part way
> through the merge window :/

Various people thought that the module.h split up was worth the effort,
so it got dropped into linux-next on Friday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Aug_2011_10_33_04_+1000_r6ADTF2JzFGey.07
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJONfRAAAoJEDMEi1NhKgbsIzoH/1Q8FE0peD1cbu+XHE9kt9Rr
D2D3hRE2BEjDf0bmGLpHeQWqfKx98D++ZAw3AtLRte0+xoEKmNCy4E1CC3yF6l3G
c6FDo8M9ZT9Ss6zJ4rO40bOX9/BW056geo6Fl3CEbKu4UwlfWxX/gJiSlCjTglom
5tQjQec7jwihRIzLKrfnsZfD0J55/kp8TwMxjnIw8q8vpuRFZhUpQ+1VcO0C5WZC
OqMu1DScrQm3rV+st+ZKMaoPklYViMEtz7Dgr7r3uJu8TCp7AjqgblpFARbZ+Jsp
8LvwEue9arE2j5Ja+cLprz61f2WOr3s6ISB5EgYXqLfzqqve+wjXncZLTqDeHKE=
=3HRf
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Aug_2011_10_33_04_+1000_r6ADTF2JzFGey.07--
