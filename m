Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1JYJgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:36:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54535 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1JYJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:36:44 -0400
Date: Tue, 25 Oct 2011 20:36:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
Subject: linux-next: Tree for Oct 25
Message-Id: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_20_36_28_+1100_z5abmhN_qNkaA_1d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_20_36_28_+1100_z5abmhN_qNkaA_1d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

*Note well*

This tree has nate had any build testing at all.  As such, it probably
doesn't build :-) This tree is really just a roll up of the current state
of the trees when the v3.2 merge window opened.  It will not be put into
the build system referred to below.

The linux-next tree remains available from
git://github.com/sfrothwell/linux-next.git .  But this will probably be
the laste one available there.

It is also back on git.kernel.org.  The patch is still absent, however.

This tree is certainly broken on sparc :-(

Changes since 20111014:

Dropped tree: ptrace (at the maintainers request)

The arm-soc tree gained conflicts against the arm tree.

The at91 tree lost its conflict.

The s5p tree lost its conflicts.

The libata tree gained a conflict against the at91 tree.

The scsi tree gained a conflict against the s390 tree.

The bluetooth tree lost several conflicts but gained another agains
Linus' tree.

The security tree probably lost its build failure.

The pm tree gained a conflict against the s390 tree.

The tip tree gained conflicts against the cputime tree.

The driver-core tree gained a conflict against the net-next tree.

The tty tree gained conflicts against Linus' tree.

The staging tree gained a conflict against the net-next tree.

The moduleh tree gained conflicts agains the xen-two and Linus' tree.

The akpm tree gained conflicts against the driver-core and block trees
and I dropped a few patches that had turned up elsewhere.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
and sparc64 defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 199 trees (counting Linus' and 27 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_20_36_28_+1100_z5abmhN_qNkaA_1d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpoMcAAoJEECxmPOUX5FEhbMP/RPn2+RX2/vvaaJJw7+UtSN8
9sPilTuWaSIFFTrHyMYm1WJ6KsTSM2HveoZdwt7fQ0ggx+bLOsGWEVpC+fxlXzpl
htpzyLBe8W8iP72VOj4qXigmA84OdRC3rZr3IVdLjIJbr82XoXWDKph4NqH+hJjb
HwnnVpPlbgOyLQiy1uiaLmmL42/9xNIF/kkaI4RV4USYpB0Fodpota1DRJhdhNxm
ch7AlsnfSl8R0rgIGRDcczvqizk6W0dD5Rw0X9a+CgFltAPv1sgM67NYR46JLVi+
Pm0bP7a1XmEsd5XjhRAtrOYC37FoXz/cyb/yZEZEmtdAarZHkUY7GYodptXNN8Tm
kF1WgUDjZaMYGrOFzet8vbjPO94ddJilD5M2YtaB+VNYvYnsFKWNhk5gEIk3tBZU
pzoCC4OYpEGYWiN3UVU5a779lMg3IOBeu61BOgkqyz/vJpp7wKGATQnkqvpIrUN+
DWGSlO4p45WVXgF4qYwuz2eJFQs/QNAYZ6TGcZfzczrPD7VC5Anyn9IgZ8j95zt9
cKpDq/g+m+1kmGf+Z1xXbcwGS3mvTMv432E6OaeiImxWIfCM68oPwCKNdyYVMSsJ
Vr/9i5pOe/lsqQr3KVaXrghlzo6PbS5fYKCbPsm/mng2et+nHAlxLg1IuSJcEGBR
l3mVSRWKNsKTyfJgU/YR
=AYcu
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_20_36_28_+1100_z5abmhN_qNkaA_1d--
