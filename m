Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab2JOWWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:22:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2JOWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:22:17 -0400
Date: Tue, 16 Oct 2012 09:22:27 +1100
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for raid
Message-ID: <20121016092227.6410ed9d@notabene.brown>
In-Reply-To: <30738.1349789438@warthog.procyon.org.uk>
References: <30738.1349789438@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f8VZGjQHFayUOiEINebZdxh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f8VZGjQHFayUOiEINebZdxh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 09 Oct 2012 14:30:38 +0100 David Howells <dhowells@redhat.com> wrot=
e:

> Can you merge the following branch into the raid tree please.
>=20
> This is to complete part of the Userspace API (UAPI) disintegration for w=
hich
> the preparatory patches were pulled recently.  After these patches, users=
pace
> headers will be segregated into:
>=20
> 	include/uapi/linux/.../foo.h
>=20
> for the userspace interface stuff, and:
>=20
> 	include/linux/.../foo.h
>=20
> for the strictly kernel internal stuff.
>=20
> ---
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74=
a8:
>=20
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegr=
ate-raid-20121009
>=20
> for you to fetch changes up to fc5a40a2301aa241eedb16caf9169ca5763707c1:
>=20
>   UAPI: (Scripted) Disintegrate include/linux/raid (2012-10-09 09:49:02 +=
0100)
>=20
> ----------------------------------------------------------------
> (from the branch description for disintegrate-raid local branch)
>=20
> clone of "disintegrate-scsi"
> UAPI Disintegration 2012-10-09
>=20
> ----------------------------------------------------------------
> David Howells (1):
>       UAPI: (Scripted) Disintegrate include/linux/raid
>=20
>  include/linux/raid/Kbuild            |   2 -
>  include/linux/raid/md_u.h            | 141 +----------------------------=
--
>  include/uapi/linux/raid/Kbuild       |   2 +
>  include/{ =3D> uapi}/linux/raid/md_p.h |   0
>  include/uapi/linux/raid/md_u.h       | 155 +++++++++++++++++++++++++++++=
++++++
>  5 files changed, 158 insertions(+), 142 deletions(-)
>  rename include/{ =3D> uapi}/linux/raid/md_p.h (100%)
>  create mode 100644 include/uapi/linux/raid/md_u.h
> .

I've pull this into my for-next branch.

Thanks,
NeilBrown

--Sig_/f8VZGjQHFayUOiEINebZdxh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUHyMoznsnt1WYoG5AQLuFg//R6Ik2GGBg9oUCmhoJLxKxLeYv4fJOCrD
7krC6h8tlHeOFrCwH8/rRfi164AIctOfqDH+SFv7yl7FPNUsx/m5GZv5LWvyTxZu
bOdgAZwyEd/g+b9LYXT1x/YGCi4VR8uYKHP3JRdDloV8RNozrFBDs6PglGYeHjt7
wvep8u1LRCy0j/tHNzHRzMoiD7b6R0foto7yBPvfaTg/WZkCCzoF1mkKQPltbEpb
isurjho+z6t5ms40RD/XtEN/W7srGYqqhM09EtBitTrvGoNrL8Obq1UOIwwShij9
6FfeLXDUwE4G83Pn2pMHLwOcW9DmN4ZUvM+4n2B0f/LjtPj8Enwbd7v9diuO8Gyy
J7DEZ8TP+ha2l82tby16DhfHLlS2KTfl71c+pF2kq8YJe6bW9djblTkxk4pEAu1X
DT6pxjIHgygPnuGyAC2vQy7pj/WmodjSXq0A72OBHee52rVlXUwRlTN7vZXtmq1W
JUk0JR2GF9i7JLBWs+TPckHgCAxBzieOwc0kl44IuWybECb94fmdtg/2bVavnAlz
mceRbdVl9y9BCwU78/M2eRHvz9Tw/mBiTLLiI/3sUTLt5q7H80DZLjNw4KA64eMN
2xX9pkbguE72ibA+HMrA2O5pkVdMrpfO3KIqWkeWEPpEXiYBmfx/LaMM62uDOrMV
2G2VKq43vsc=
=HPvH
-----END PGP SIGNATURE-----

--Sig_/f8VZGjQHFayUOiEINebZdxh--
