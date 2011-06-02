Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1FBBia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 21:38:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49830 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab1FBBi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 21:38:29 -0400
Date: Thu, 2 Jun 2011 11:38:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: clean up time (pass 1)
Message-Id: <20110602113826.a41bbd3d.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTim6MbS1E=9LyX=rsDr+JNuojPC4GQ@mail.gmail.com>
References: <20110601110616.861247de.sfr@canb.auug.org.au>
	<BANLkTim6MbS1E=9LyX=rsDr+JNuojPC4GQ@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Jun_2011_11_38_26_+1000_Vm8heZEGpS31nyoN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Jun_2011_11_38_26_+1000_Vm8heZEGpS31nyoN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Phillip,

On Thu, 2 Jun 2011 02:26:07 +0100 Phillip Lougher <phillip.lougher@gmail.co=
m> wrote:
>
> > squashfs
>=20
> This is a surprise ... I'm sure I had commits in my squashfs
> linux-next tree at the opening of the last but one merge window...
>=20
> Linux 2.6.38 released 14 Mar 2011
>=20
> $ git log --pretty=3D"%ci %s"
> ...
> 2011-02-28 18:43:48 +0000 Squashfs: wrap squashfs_mount() definition
> 2011-02-28 18:35:44 +0000 Squashfs: xz_wrapper doesn't need to include sq=
uashfs_
> 2011-02-28 18:35:36 +0000 Squashfs: Update documentation to include compr=
ession
> 2011-02-28 18:35:28 +0000 Squashfs: Update Kconfig help text to include x=
z compr
> 2011-02-28 18:34:24 +0000 Squashfs: add compression options support to xz=
 decomp
> 2011-02-28 18:21:59 +0000 Squashfs: extend decompressor framework to hand=
le comp
> 2011-02-07 16:03:55 -0800 Linux 2.6.38-rc4

plus or minus 1 day (and timezone jitter :-)):

$ git rev-list --no-merges next/20110314/origin..next/20110314/squashfs | w=
c -l
0
$ git rev-list --no-merges next/20110315/origin..next/20110315/squashfs | w=
c -l
0
$ git rev-list --no-merges next/20110316/origin..next/20110316/squashfs | w=
c -l
6

It doesn't really matter, it was just a quick metric to choose a subset
of trees to look at.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Jun_2011_11_38_26_+1000_Vm8heZEGpS31nyoN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5umSAAoJEDMEi1NhKgbsSoEIAIdvf18p4+w59iB97hutZ/S9
i5YZyOFsTvxet09vFidCxPUj0uuY25pYKBsLkn3oZZ9Zaq3ut2eSOML6aSakxhT6
WcMNzQSsUDpjXpwU0l04LLVbFrnLEiQVTRYJdmzNnQKT8BIQsyz1vvoyA7mYjkgl
mb/FC6QLlCkq4yoyzPI9qWxPan9j18tb9Ihsgq9IXJDrXMuRWRSb8Wwzr/I81R3A
pLro+SHErASftdO9b1TEDJxNL6TiL0Tko5mqFt4nUEN0lh83XFzOwmzogxfYrwOM
zpzoHLa+GuuKCkXkMSbQGc7/mDz4/Y9z7lC/GQY6ktCKgMeFVveIRfT9chdovfg=
=Mcpy
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Jun_2011_11_38_26_+1000_Vm8heZEGpS31nyoN--
