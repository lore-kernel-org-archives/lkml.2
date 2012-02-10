Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891Ab2BJSmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:42:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52372 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860Ab2BJSmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:42:05 -0500
Message-ID: <1328899454.22240.91.camel@sauron.fi.intel.com>
Subject: Re: [Cocci] Re: [PATCH] scripts/coccinelle/misc/boolinit.cocci:
 semantic patch for bool issues
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Gilles Muller <Gilles.Muller@lip6.fr>, bruce.w.allan@intel.com,
        rusty@rustcorp.com.au, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Julia Lawall <julia@diku.dk>
Date: Fri, 10 Feb 2012 20:44:14 +0200
In-Reply-To: <1328895943.14197.1.camel@joe2Laptop>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1328895943.14197.1.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YaSLZbFRKIKS1UWIY2FL"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YaSLZbFRKIKS1UWIY2FL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-10 at 09:45 -0800, Joe Perches wrote:
> On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Thanks Julia.  It seems to work well.

I wonder though, why would we want to change if (a =3D=3D true) with if (a)
etc? Julia did not provide the explanation in the commit message but
referred to you and Rusty in the semantic patch.

--=20
Best Regards,
Artem Bityutskiy

--=-YaSLZbFRKIKS1UWIY2FL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPNWV+AAoJECmIfjd9wqK08oEP/0R06GN0mFsjO7tmHQCK1n4y
5Pmx6Lb1OK73cnQ6TmxOUmdSVEIj9BESVwljGy6yL+Q0whQqltJsD1cBxXo7rcCe
SfvKM6aWxX6Irlws2QzP98MW4sdkjZFMTBPUqtEjJ+aEjs25wGyxVhzCocdLLMCR
f0xhuYRg+CsEDDUfAHac58cE2NKGbLtj2YDAckzWtBaeV2/+v4TIXfqktrX7hHkO
lVMy7Wr0U3TYuMrtd2464zVVoJsALyNVY8dVjzzaLhI9Q2AvHhCuzdaaajTInix5
T10bVSn8i3ELF77S7z8BezlQI8ttI75+w41R4BDiq4C3mLx8a0vsZuCOTBIu/YKF
V76H7V8KEWavrFvzArRw8lH0JsrzCKWl3bEmYCQJt7OVBKZYumA5T/GHnljJFX6V
WZGIvLalW3OMliXCFGp5pQdzGfPs5I8GmVqmiU4iSJCEvCBUqaO7E/Lf8bwYOiA4
iKrUufgMx/HEQsIfyo96y6uy5eHYwzCafEK509xuUdNwHyyHU0Fzn6MhWp7diRSJ
UaRIwfvUUJVe8ARmy9Vxbl/5Suutj/lVDrQU9eg1J7QycuUEwiTWMGg+UB9hy0lu
gYbN9TbtNV5Smvkln5Bpoz5eOtN7rGQU2hIn5M7IHBH0KWZw0wOREBcGrNkyUZEF
slXcI/tMGHFm8CXY2zfV
=2bG6
-----END PGP SIGNATURE-----

--=-YaSLZbFRKIKS1UWIY2FL--

