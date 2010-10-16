Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0JPW0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:26:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52470 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab0JPW03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:26:29 -0400
Date: Sun, 17 Oct 2010 09:26:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
Message-Id: <20101017092621.67ac74e0.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Oct_2010_09_26_21_+1100_m/pDEIFo7/P.Q_Rf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Oct_2010_09_26_21_+1100_m/pDEIFo7/P.Q_Rf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Sat, 16 Oct 2010 17:31:34 +0200 (CEST) Geert Uytterhoeven <geert@linux-m=
68k.org> wrote:
>
> On Sat, 16 Oct 2010, Geert Uytterhoeven wrote:
> > 162 regressions:
> > 	src/fs/9p/vfs_inode.c: error: implicit declaration of function 'inode_=
setattr':  =3D> 1267
> > 	src/include/linux/vgaarb.h: error: asm/vga.h: No such file or director=
y:  =3D> 34:21
>=20
> These two are reported for m68k/allmodconfig:
> http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/, but I cannot
> reproduce them.

Neither of those errors are reported in the above build result ...

That first error was first reported on Aug 11
(http://kisskb.ellerman.id.au/kisskb/buildresult/3021626/) but seems to
have be fixed by Aug 12
(http://kisskb.ellerman.id.au/kisskb/buildresult/3022316/).  See commit
8cef9c67356eca3e6502444c8075a06c86872abf ("v9fs: fixup for inode_setattr
being removed"), one of mine.

That second error was first reported on Aug 6
(http://kisskb.ellerman.id.au/kisskb/buildresult/3012805/) but seems to
have been fixed by Aug 13
(http://kisskb.ellerman.id.au/kisskb/buildresult/3026080/).  Indeed it is
fixed by commit 71beefe8c0b9e12ed4ac9fe13b98a035ddeaf8eb ("vgaarb: drop
vga.h include") which was in response to a report from you.

So, I suspect that there maybe something wrong with the reports you are
working from.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__17_Oct_2010_09_26_21_+1100_m/pDEIFo7/P.Q_Rf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMuiaNAAoJEDMEi1NhKgbspZUIAIKH2CCGun+4ytwrobOgeDyw
bkUZnDQF4gAT72aRChTPxU1d0FQaeloB9fw6sgcOqyRUOWVuZg9dSNuMjUbYbpiJ
Zy3SUSXRVKcg5QHEeMnm2eKbvWSHEDH0hHKFeoucW+54vM8uX0Iy/I8bYrum7BiJ
shfIsZ7mOz4zy9/Gis/n2rhaGOqIO85PGf8nbHle4gNx+EsgGWDgt5ieWJBOJ5dA
SiSjS0OOJSqWW0/EuJZf11Y8KGQA1RpuC0VIMlnYHaV3oTssK+z9BJ208q5q6Ro0
lwV8ati3RTIaBXMVYRyP793NkMq9zInBvx8BUY9+GZ+wtxaW8R1FNTQseamPqsE=
=JVIu
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Oct_2010_09_26_21_+1100_m/pDEIFo7/P.Q_Rf--
