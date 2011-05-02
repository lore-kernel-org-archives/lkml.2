Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1EBExo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 00:53:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34645 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1EBExm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 00:53:42 -0400
Date: Mon, 2 May 2011 14:53:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-Id: <20110502145338.7be2fdbc.sfr@canb.auug.org.au>
In-Reply-To: <20110502142454.a7091ad5.sfr@canb.auug.org.au>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
	<20110502022417.GA11804@redhat.com>
	<20110502134524.40da4245.sfr@canb.auug.org.au>
	<20110502142454.a7091ad5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_May_2011_14_53_38_+1000_vioKV2+=vaV.5zRZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_May_2011_14_53_38_+1000_vioKV2+=vaV.5zRZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

hmmm,

On my build machine:
$ /opt/cross/gcc-4.4.5-nolibc/x86_64-linux/bin/x86_64-linux-gcc -Wno-unused=
-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
0
$ /opt/cross/gcc-4.4.5-nolibc/x86_64-linux/bin/x86_64-linux-gcc -Wunused-bu=
t-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
cc1: error: unrecognized command line option "-Wunused-but-set-variable"
1
$ gcc -Wno-unused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
0
$ gcc -Wunused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
cc1: error: unrecognized command line option "-Wunused-but-set-variable"
1
$ gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion=3D'Debian 4.4.5-8' -=
-with-bugurl=3Dfile:///usr/share/doc/gcc-4.4/README.Bugs --enable-languages=
=3Dc,c++,fortran,objc,obj-c++ --prefix=3D/usr --program-suffix=3D-4.4 --ena=
ble-shared --enable-multiarch --enable-linker-build-id --with-system-zlib -=
-libexecdir=3D/usr/lib --without-included-gettext --enable-threads=3Dposix =
--with-gxx-include-dir=3D/usr/include/c++/4.4 --libdir=3D/usr/lib --enable-=
nls --enable-clocale=3Dgnu --enable-libstdcxx-debug --enable-objc-gc --with=
-arch-32=3Di586 --with-tune=3Dgeneric --enable-checking=3Drelease --build=
=3Dx86_64-linux-gnu --host=3Dx86_64-linux-gnu --target=3Dx86_64-linux-gnu
Thread model: posix
gcc version 4.4.5 (Debian 4.4.5-8)=20

On master.kernel.org:

$ gcc -Wno-unused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
0
$ gcc -Wunused-but-set-variable -c -xc /dev/null -o /tmp/xx.o; echo $?
0
$ gcc -v
Using built-in specs.
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=3D/usr --mandir=3D/usr/share/man --i=
nfodir=3D/usr/share/info --with-bugurl=3Dhttp://bugzilla.redhat.com/bugzill=
a --enable-bootstrap --enable-shared --enable-threads=3Dposix --enable-chec=
king=3Drelease --with-system-zlib --enable-__cxa_atexit --disable-libunwind=
-exceptions --enable-gnu-unique-object --enable-languages=3Dc,c++,objc,obj-=
c++,java,fortran,ada --enable-java-awt=3Dgtk --disable-dssi --with-java-hom=
e=3D/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile --ena=
ble-java-maintainer-mode --with-ecj-jar=3D/usr/share/java/eclipse-ecj.jar -=
-disable-libjava-multilib --with-ppl --with-cloog --with-tune=3Dgeneric --w=
ith-arch_32=3Di686 --build=3Dx86_64-redhat-linux
Thread model: posix
gcc version 4.4.5 20101112 (Red Hat 4.4.5-2) (GCC)=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_May_2011_14_53_38_+1000_vioKV2+=vaV.5zRZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNvjjSAAoJEDMEi1NhKgbsmYcH/RjbZMN5iI8jo6nSe21rSFcQ
VdGyrtSyAGGbt10TdsO6QplOtx4jHO5InY1PD1uN+zTlJPc9sZZpm6cWEDgLQXJW
5OMe5KRDWQE8f5LMSSVQL/3TxK2x2NU0mAa4ZhFlWO3FWzR8Xh+GRCznq63F33fz
jmySA9BchVZLX+RvLtZwIIlX0Wn/fZiQsCcKus1KDN6DPCfycJ8Y7tHAbbr8BEvl
FeISLXkRQivzrYj3RVVrT6l8mGf3crJGxHEZR4BEd9inq0WxF5bGlnIlKw6wE0PU
naRmnYmbPPYBlkfw8Nor/wSCu7v9eGudgZb7YDil1EP6xo/DhSvkvCeka2Y7Ask=
=BnoZ
-----END PGP SIGNATURE-----

--Signature=_Mon__2_May_2011_14_53_38_+1000_vioKV2+=vaV.5zRZ--
