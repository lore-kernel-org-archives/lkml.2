Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1K1NOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:14:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50232 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1NOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:14:05 -0500
Date: Tue, 29 Nov 2011 00:13:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20111129001353.399142710ab77822b29552f0@canb.auug.org.au>
In-Reply-To: <20111128113056.2099e4c3@lxorguk.ukuu.org.uk>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
	<CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
	<20111128135317.a99880b234c6c060a622fa31@canb.auug.org.au>
	<20111128113056.2099e4c3@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_00_13_53_+1100_HYZa52GMh959PWo1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_00_13_53_+1100_HYZa52GMh959PWo1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Mon, 28 Nov 2011 11:30:56 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> On Mon, 28 Nov 2011 13:53:17 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > On Fri, 25 Nov 2011 10:34:19 +0000 Dave Airlie <airlied@gmail.com> wrot=
e:
> > >
> > > I just pushed jbarnes patch into my tree for now, at pushed out the
> > > mainline gma500 code with it.
> >=20
> > And it is a mess (see my linux-next reports).
>=20
> Well its very hard to sort stuff out when you are juggling a cross tree
> set of dependancies and someone pointlessly stops one of them being
> visible in next for ten days.

The mess in the drm tree has nothing to do with the staging tree.  It has
happened because the merge of your gms500 changes into the drm tree
interacted with other changes in that tree and the interactions were not
fixed in that tree.

You did read my error report from today, didn't you?  The build failure
was in drivers/gpu/drm/gma500/psb_drv.c.  The warnings indicating other
unfixed interactions were in drivers/gpu/drm/gma500/framebuffer.c.

As far as I can see, building the gma500 driver in the drm tree (on its
own) will fail.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Nov_2011_00_13_53_+1100_HYZa52GMh959PWo1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO04kRAAoJEECxmPOUX5FEu6QP/jnfwfTtNMSQBWByhSKZonnm
iI6YCJrLA3AF0V5/w5Zp8WvE7jZui25jsPxzbBxmVUPuzRQSOg1gR+wgaYZyvuyl
A7P6H4UxaUY0BfVavZm2u+N4a8UIB0eT8TOA/QBpGYMbY1lnjaMYyGCS7zdM0eDZ
6Epib4hyr3fMA6DfjYn2S8H3mOl0lrhDnWqWl/o0ZjEMO7P0rx1mWnmn3f3D2cB9
kAz8L1XA0XC7A/cals6fXlnAMxj8nXZjhszpP3PQ46AWhDE7TeYobu4jaAW8pIay
m0+966mC/cMSFR4kMpJpbfdQ7FwPgV2pxDQe8xnj2mQ5vNPRhdA8NFGnh61L62H9
5aRJW1IPgdRsYPRRMvRu//UvBitnXHrAB3y7b/lrEqx65ZUfzQBDL24bTFncukVh
TxB+jHPkmb/fRnGgcDZOt1pIiAMPiRM0KQMvIHh8q6vq3kS8e+ILc23vxN+fP+pm
2CU2YXGAodAFiBIClsbH+qi31AXMxgM+oEWJSemSbRnju6MaBlMU8kkg/51JqH+h
g6yxGpYdQl7SKA/qsE/YbZffYW1YIMR16ZHIbAQf8SzTSw+1L5Gozy2azKyi9I/9
HvYmvr1F/bDgqovpAyhsuC0eplV8WTw160bmdnFcV7DVtXqfRtwwzXhcraCcx/qz
HG+ovj4n2GWUj2ku4dQ/
=Ss8z
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_00_13_53_+1100_HYZa52GMh959PWo1--
