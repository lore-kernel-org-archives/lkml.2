Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1GZFZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:25:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33110 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GZFZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:25:15 -0400
Date: Tue, 26 Jul 2011 15:25:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 1.5
Message-Id: <20110726152507.137a697e31b3ff48a17e08e8@canb.auug.org.au>
In-Reply-To: <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
	<20110726033535.GA11939@x4.trippels.de>
	<CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Jul_2011_15_25_07_+1000_uW5lY73e.hVIuJ0V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jul_2011_15_25_07_+1000_uW5lY73e.hVIuJ0V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 25 Jul 2011 21:52:57 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, Jul 25, 2011 at 8:35 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> >
> > This breaks the build for "# CONFIG_FS_POSIX_ACL is not set" configs:
>=20
> Of course it does. And as usual, my exhaustive testing was for the
> allyesconfig case, rather than doing both allyesconfig and allnoconfig
> like I should.
>=20
> Bah.
>=20
> Does the attached trivial patch fix everything for you?

It fixes my allnoconfig builds in linux-next today (which were broken).

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Jul_2011_15_25_07_+1000_uW5lY73e.hVIuJ0V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLk+zAAoJEDMEi1NhKgbsxy8H/2lqkH44RCq7F6e8U/jZlLGX
raVike0k1dqzh3F0knWqIVr5DDKzmP6zKrwuHxAD2HO+1FsOjmsPzV9v/276+q4E
c6J0nhEf2gg1UUpEUPrB+qhbViw/GIq5ZfLr4FSMqLMf93sdq8oMX+k2VTHtk/W9
DkihMmK+AgPKEz8MNt5dMRpKVpFNjgo+3UlUfodX9AES7Dwi9VdaeKkw8B7qQyaV
Pj4bUPHQarNhqoYnTCAMjQbxQDA686fSJoGG1NMJu3QzHFT49RWQARltP0+3sJ+y
PA127g+dGwh9MvKYB3IWHV3sFWNhlWpJja6hWOLkxhVYK45xJI9t4Ug5aYzqLb0=
=ec7N
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jul_2011_15_25_07_+1000_uW5lY73e.hVIuJ0V--
