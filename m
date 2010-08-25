Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0HYANa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:13:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52691 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0HYAN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:13:27 -0400
Date: Wed, 25 Aug 2010 10:13:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
Message-Id: <20100825101320.bed89b2a.sfr@canb.auug.org.au>
In-Reply-To: <4C740450.3030000@cs.helsinki.fi>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au>
	<4C740450.3030000@cs.helsinki.fi>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Aug_2010_10_13_20_+1000_lmk9PtW3NYyEHAkt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Aug_2010_10_13_20_+1000_lmk9PtW3NYyEHAkt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pekka,

On Tue, 24 Aug 2010 20:41:36 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wr=
ote:
>
> Thanks for the report. The problem should be fixed by this commit:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/penberg/slab-2.6.git;a=3Dcomm=
itdiff;h=3D5792949c540c9fd719c3fc0d6edc97374222e792

A small point:  I did *not* review that patch.  I *did* report the bug
(and seemingly provided the commit message).

Thanks for the build fix.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Aug_2010_10_13_20_+1000_lmk9PtW3NYyEHAkt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdGAgAAoJEDMEi1NhKgbsKYEIAJBmQiqjDVLrgtIStg+aLaqd
LZ0RpkwkiKMphQrgVBJMhPUZMpDuaYa/2me2+n4l6a+o8Je5fXsQLRiVZ73ie3U3
rnb6Fl6y10laSeIRfJ/n5fwXu/kgLvPGDKvvSJLIKaeV8qEr8EjHpOcUlTMxeHH+
9JJNb3qN1gZdmkf4vTwkkjKvVgp1PEoNqGJJXErQ+GXNPyrrmBkAGsvBxA8N8fpn
JWB4nxUhZ4J/dxe6pewR4BHlx/tYY6PaiYYFLY17K7lgvlIo0P/oomvP7NS17FtN
vX7I2nZI/VVeNdrovBgEkTAQNfCygNJC6vJNVNu/8VupxrmMzTiUFtrqgDF0/yY=
=SKLw
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Aug_2010_10_13_20_+1000_lmk9PtW3NYyEHAkt--
