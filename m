Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1K1Nxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:53:53 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55732 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1Nxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:53:52 -0500
Date: Tue, 29 Nov 2011 00:53:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20111129005341.c5caf7f353876a0dd4764d3c@canb.auug.org.au>
In-Reply-To: <20111128131847.48bffb93@lxorguk.ukuu.org.uk>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
	<CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
	<20111128135317.a99880b234c6c060a622fa31@canb.auug.org.au>
	<20111128113056.2099e4c3@lxorguk.ukuu.org.uk>
	<20111129001353.399142710ab77822b29552f0@canb.auug.org.au>
	<20111128131847.48bffb93@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_00_53_41_+1100_bDGIl9oXFbxnwV/B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_00_53_41_+1100_bDGIl9oXFbxnwV/B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Mon, 28 Nov 2011 13:18:47 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> > > Well its very hard to sort stuff out when you are juggling a cross tr=
ee
> > > set of dependancies and someone pointlessly stops one of them being
> > > visible in next for ten days.
> >=20
> > The mess in the drm tree has nothing to do with the staging tree.=20
>=20
> I would suggest you re-read the paragraph above, and the mails I sent you
> about marking the staging gma500 tree broken (which given nothing
> happened in response to any of them I imagine you didn't).

When I originally reported this problem, you responded:

> gma500 is frozen pending Dave Airlie's applying the patches moving it out
> of staging.
>
> <Prod, prod>

Which I assumed was aimed at Dave.  Then Jesse (whose changes broke the
code in staging) responded with a patch which I assumed that Dave would
do something with.  Then the next day you responded with:

> If the staging gma500 is causing this still please resolve it by marking
> the GMA500 in staging "&& BROKEN" for the moment.

And maybe I should have done something then.  I fall back on the excuse
that I have about 200 trees to merge every day and when I use to fix
things for people I used to have lots of 12-16 hour days ...

> And if you still think that blocking the DRM tree from -next for ten days
> thus stopping all sorts of other integration work and forcing people's
> hands on moving from staging and the like didn't cause the problems and
> is the right policy then we'll just have to agree to differ.

If you are trying to get something merged into the drm tree, you should
be working with the drm tree and with the drm maintainer, not
linux-next.  Linux-next is here to find integration problems between
trees and across architectures not to find problems with changes within
one tree.

And I repeat, the breakage today is nothing to do with the staging tree,
it is in the drm tree and how your gma500 changes were merged there (and
to be clear, there is nothing wrong with the gma500 changes per se).

In the future, I will try to remember to "kill staging first", but this
is the first time it has come up since staging started being built by an
allmodconfig build (which it used not to be - and that change was not my
choice).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Nov_2011_00_53_41_+1100_bDGIl9oXFbxnwV/B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO05JlAAoJEECxmPOUX5FEHZ0P/2rBH6LHZRA9CpBZE5op5ywW
jqQLAlI9JcwVkwChpTTfaI71fZMTFin/CBIpNY9hbjkweMskzxQMfZFs+nQp6AVW
GoA6GEQYZNUelhIJuRpEqgSNoicrEuPDGMiA0h6hPj8mjZicR5VlYjh6fOHKhS3K
vhl9GccBWT6s7GNupsaY0v7QYTcqlMOfoBDFgxSLHIAvQ75xmOASVSy72IwGQJKt
F8LoDkPifnCsw+GENo/jJPWvHmwfB9oA3lGnfNQzzreGZsUYKGuNaNnEht3KF4Hd
Rp0X8g3UMFJITdHq+jSh4382LMHq1k79ES8zh8NDTJmWD/v3Gyo81lsxc6XyGDNd
/GSfDSF8LLuP/85p68lxpA1ZG6c+YZJY80AF5gI6pXRTikHB0V53ghYHv5ha3zc7
298LEXqLBqpRkGt3CUpmPiaT2R65zKByAQhj0IUzVdHWUkX4PiLRxAd3kYvaX7wY
aenuI8l9FLm8Sg7x4tygnYaKINtabrG6seUzmFlzA5pYIJ/IFCyoCfHVo6r6g8JP
Ha7tuMVPVYNvZrDLJjk/jy7CbEi9EL8pCRnuPy0tPrGWOsmkSYVkLA5TB4zdV7Hr
e7/lL9nEqTKL9Z7xt7qs6zkYe6xpqPO/oWODCgvkqAJLJLYKqY9USFVRdnYqwbyV
iDXALHH/IxpK2dVvNJ8q
=hXXv
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_00_53_41_+1100_bDGIl9oXFbxnwV/B--
