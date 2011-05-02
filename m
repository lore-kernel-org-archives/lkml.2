Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1EBEoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 00:44:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44888 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab1EBEoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 00:44:19 -0400
Date: Mon, 2 May 2011 14:44:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-Id: <20110502144414.e0adfc69.sfr@canb.auug.org.au>
In-Reply-To: <20110502040216.GC11804@redhat.com>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
	<20110502022417.GA11804@redhat.com>
	<20110502134524.40da4245.sfr@canb.auug.org.au>
	<20110502040216.GC11804@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_May_2011_14_44_14_+1000_6ueHkQ6AVjw3icyN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_May_2011_14_44_14_+1000_6ueHkQ6AVjw3icyN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 2 May 2011 00:02:16 -0400 Dave Jones <davej@redhat.com> wrote:
>
> Subtly different from what I wrote.. the version I wrote did this ..
>=20
> +KBUILD_EXTRA_WARNINGS +=3D $(call cc-option, -Wunused-but-set-variable)

Due to other changes in the kbuild tree, I suspect.  However, as you say,
this part is not relevant to the warning I am getting.

> I just tested with the gcc 4.4.5 on master.kernel.org, with a tip of Linu=
s'
> tree with my original diff, and it didn't complain at all.

Also see my other email.  For a i386 defconfig build, I get this warning
only twice, for a sparc64 defconfig I get 4 and for a sparc32 defconfig,
none:

At top level:
cc1: warning: unrecognized command line option "-Wno-unused-but-set-variabl=
e"

> What does gcc -v say ?
> gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC)  seems to be fine.

$ /opt/cross/gcc-4.4.5-nolibc/x86_64-linux/bin/x86_64-linux-gcc -v
Using built-in specs.
Target: x86_64-linux
Configured with: /home/tony/buildall/src/gcc/configure --target=3Dx86_64-li=
nux --enable-targets=3Dall --prefix=3D/home/tony/buildall/cross.x86_64/gcc-=
4.4.5-nolibc/x86_64-linux/ --enable-languages=3Dc --with-newlib --without-h=
eaders --with-system-libunwind --disable-nls --disable-threads --disable-sh=
ared --disable-libmudflap --disable-libssp --disable-libgomp --disable-deci=
mal-float --enable-checking=3Drelease --with-mpfr=3D/home/tony/buildall/src=
/sys-x86_64 --with-gmp=3D/home/tony/buildall/src/sys-x86_64 --disable-boots=
trap
Thread model: single
gcc version 4.4.5 (GCC)=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_May_2011_14_44_14_+1000_6ueHkQ6AVjw3icyN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNvjaeAAoJEDMEi1NhKgbs1q4IAIG5vW1gmwfjq7w2+rftXlao
Fyjpu3fS3b0BmH1Wvvvz08E2Ml3iUD5j77r+YGBf+Ejp7vteyGzH4yvgIIA/owUF
C9fysu2I1sX1PIhipoTsPWYdkLrUmPydLB0VEcatrHiEwpeYZJdW286fLKqQiVDO
D/mkQmCBUha7jYYjCMXpO4/O3Y7cDMMuKur3hswDkjOR7TbEBB8pEau7iiqe3x9h
NwseyNV4oBghzClknjnMjwEK0YaLWm2aNWuP4KyzWYOK6jOgRFItzVLyLoQLndi2
m8T1jz6hsi+lXeZQ9koag45QAVZvUscI9MKrq/otOrfmcAgS5ZPv5DObR67Mylc=
=1l+7
-----END PGP SIGNATURE-----

--Signature=_Mon__2_May_2011_14_44_14_+1000_6ueHkQ6AVjw3icyN--
