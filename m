Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1IVBY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:24:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46726 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IVBYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 21:24:55 -0400
Date: Thu, 22 Sep 2011 11:24:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, akpm@linux-foundation.org
Subject: Re: linux-next: tmem: temporary home for tmem.git tree (for
 frontswap, which is the final core kernel patchset for tmem)
Message-Id: <20110922112448.87786ddaeebd02556f36227c@canb.auug.org.au>
In-Reply-To: <b6034dd3-1750-49b5-b466-c125c9704db2@default>
References: <b6034dd3-1750-49b5-b466-c125c9704db2@default>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_11_24_48_+1000_vu0FqVommPv=FKSd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_11_24_48_+1000_vu0FqVommPv=FKSd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 21 Sep 2011 12:18:19 -0700 (PDT) Dan Magenheimer <dan.magenheimer@o=
racle.com> wrote:
>
> There's a few tweaks in the tmem/frontswap patchset (for which
> the current version was last pulled into linux-next from kernel.org).
> Changes are mostly cosmetic and mostly in response to feedback from
> Andrew Morton, with a bit of patchset restructuring suggested by
> Konrad Wilk.  I've been hoping that kernel.org would come back up
> but if it's not too much trouble to switch temporarily, please
> switch tmem to:
>=20
> git://oss.oracle.com/git/djm/tmem.git#tmem
>=20
> I would appreciate having the exposure on the latest bits
> before the 3.2 merge window.

I will switch to that tree from today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Sep_2011_11_24_48_+1000_vu0FqVommPv=FKSd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeo5gAAoJEDMEi1NhKgbsUwoH/Aie2f7XsUBcB4daTkI16VzG
nTu9c5zdgkoZoDEdGvj1TQQPo+8tq+SyyQ+i4nXvT1UuK477GhZT9bg6VPGUrAQ2
F1O5LLSB16/s6TmwvxhLx4SjUT39Lzg+KaIOlcTmB5spCNjhDkuP1rml7IYhKvVR
0wJIJcn2x5WZC2h76ZDVRhyBbOwM7wkMk8YZWqItVMJoRJ6QFDJHBkVvt2SzAAFM
t+r/kJ8D8FtLEYoU1XFKrC9xMkN1fvdhnKZQKm9Wy2zM9UU9LmFIDDlQ5K6w84TK
C/pd1WCZ5XVsDnW0m+a42pOdPXnk/drVZAUZK2IWlhxH3cW17nkyCLXdvVI6PPw=
=DuUf
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_11_24_48_+1000_vu0FqVommPv=FKSd--
