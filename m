Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0HKSvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:51:10 -0400
Received: from gold.linx.net ([195.66.232.40]:34708 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab0HKSvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:51:08 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 14:51:08 EDT
Subject: Re: [PATCH -next] v4l2-ctrls.c: needs to include slab.h
From: Tony Vroon <tony@linx.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <20100809105635.4208c7ac.randy.dunlap@oracle.com>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>
	 <20100809105635.4208c7ac.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ndn/uexTQsPRW6cROLJg"
Organization: London Internet Exchange (LINX; AS5459)
Date: Wed, 11 Aug 2010 19:45:42 +0100
Message-ID: <1281552342.5092.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ndn/uexTQsPRW6cROLJg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-08-09 at 10:56 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> v4l2-ctrls.c needs to include slab.h to prevent build errors:

This appears to have been missed. Running mainline git:
Linux amalthea 2.6.35-06998-g3d30701 #1 SMP Wed Aug 11 15:33:16 BST 2010
x86_64 Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz GenuineIntel GNU/Linux

Enabling Video 4 Linux results in the breakage promised by Randy:
> drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of func=
tion 'kzalloc'
> drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of func=
tion 'kfree'
> drivers/media/video/v4l2-ctrls.c:1528: error: implicit declaration of fun=
ction 'kmalloc'

Please apply.

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-ndn/uexTQsPRW6cROLJg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkxi79YACgkQp5vW4rUFj5rqzACfTKpzexak+mpOUTP6P8Lqp97s
b4wAnRK+uucSDuRX8Gj2l5oiH2pp5DL2
=R0eM
-----END PGP SIGNATURE-----

--=-ndn/uexTQsPRW6cROLJg--

