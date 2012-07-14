Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2GNWTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 18:19:36 -0400
Received: from smtp-2.hut.fi ([130.233.228.92]:50958 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab2GNWT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 18:19:28 -0400
Date: Sun, 15 Jul 2012 01:19:13 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: kmemcheck: Fatal error; system fails to boot when kmemcheck
 enabled
Message-ID: <20120714221913.GA8653@sli.dy.fi>
References: <20120712213305.GA11128@sli.dy.fi>
 <CAOMGZ=F2SkQN1sw9vaDqukFUi0QSaQ=tJOhXjvnJhNz+VYEcKg@mail.gmail.com>
 <20120714010902.GA8741@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20120714010902.GA8741@sli.dy.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 14, 2012 at 04:09:02AM +0300, Sami Liedes wrote:
> > Another thing you can try is try to figure out when things went wrong.
> > If you test an old kernel like 3.0 or so -- and find that kmemcheck
> > works, that's great, it means we have a way to narrow it down further.
> > I may also try your config here to see if I can reproduce it.
>=20
> I'll probably test 3.0 and could even try to git bisect within a few
> days.

I tested with 3.0.36. It does not boot either.

Also, I tested with both 3.0.36 and 3.4.4 with kmemcheck=3D2. With that
parameter, both boot fine. Curiously, when booting with kmemcheck=3D2, I
can see absolutely no messages about kmemcheck, just as with
kmemcheck=3D0, and the machine boots fine. The crashes happen only with
kmemcheck=3D1. The speed suggests to me that with kmemcheck=3D2, kmemcheck
is actually possibly not enabled at all for some reason.

One curious result with 3.0.36: With nosmp, it panics so early that
I'm unable to capture the dmesg (I may experiment with getting some
other video mode than 80x25; not sure if it's possible...). *Without*
nosmp, it boots much further, and I can actually get the dmesg via
netconsole. I tried this a couple of times, with always the same
result.

Dmesg from 3.0.36 without nosmp:

   http://www.niksula.hut.fi/~sliedes/kmemcheck/nc.log.3.0.36

A photo of the (final portion of the) backtrace for 3.0.36 with nosmp:

   http://www.niksula.hut.fi/~sliedes/3.0.36.kmemcheck.nosmp.bt.jpg

Dmesg from 3.4.4 with kmemcheck=3D2:

   http://www.niksula.hut.fi/~sliedes/kmemcheck/nc.log.3.4.4.kmemcheck-2

Dmesg from 3.0.36 with kmemcheck=3D2:

   http://www.niksula.hut.fi/~sliedes/kmemcheck/nc.log.3.0.36.kmemcheck-2

	Sami

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJQAfBhAAoJEKLT589SE0a0HlcQAKiPl3JoYCghDB8vTMRsAoTO
029ZJMAFgTJyOj91sk0AMqgawFfIpCqhsUQnhkrPFU/vyPUDdz4/gldl9Rq3/jth
P8K9xTS6W+C5SNCcx32Nmgd3nXrczBDamO8VxVm+N1CPHeqqR4H/mvMvjBJC21sb
Z0PvVBD0FUFhUrEErjt6AAncXRUtORKEgo6qrsVoWYwpgz0bZ6ZNu9pDslzbma2d
2wUeO6p6C9+DP3DSMrTEvzTE8ZVL9DLC49xZo4ubcEiUkXfakml+8cFyLhJvCN+6
mhgmeF9/jcaTh8KQBsi4BX1+1TWjTx7NZ2BmRnMkFbyJjz25ne3L5NR9W/tQI8Pq
WyRWi8vCMAQw07caylRF8BVJvwm5Nyaqf+LVMR4dYpgDL0HCz256rPY8InWbbbCQ
txJVawlg9lpZwlpfAfJYhRNVYztgyBiiO0DtveDELqEG8JfeZ0dZrCTNQl7YK3rp
Q3kZX7TgpgO1j6aFzCyE5YBTl7SGlR6zYIxiHvWlJipfxjBkWo3qKpM4PfIPPI6f
/zBsW5buGcVcScuaYlx18bFSXaQcd4seHCd+8aEKQiwLnsmEM/BeaZimeUcfOigL
dEboGNqK3gOv7A285Cy/VoPH3yZ36XTl5xUV5xQMIxBmtg82ngu+w/OyFt7WVgrD
OloSiVcrq4WvAR0AzJRu
=UxAA
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
