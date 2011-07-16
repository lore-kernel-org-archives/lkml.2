Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1GPOI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 10:08:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51112 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab1GPOIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 10:08:24 -0400
Date: Sun, 17 Jul 2011 00:08:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 16
Message-Id: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Jul_2011_00_08_15_+1000_a8nom66A1=ARShtk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Jul_2011_00_08_15_+1000_a8nom66A1=ARShtk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20110707:

New trees: arm-soc, openrisc and .

Dropped tree: arm-soc.
=09
The pci-current tree lost its build failure.

The arm-soc tree has complex conflicts against the arm tree so I have
dropped it for today.

The arm-lpae tree lost a conflict.

The vfs tree gained some build failures so I used the version from
next-20110707 and then added a couple of patches.

The jdelvare-hwmon tree gained a build failure so I used the version from
next-20110707.

The idle-test tree lost its conflict.

The net tree lost a conflict.

The rr tree lost its build failure and gained a conflict against the
openrisc tree.

The block tree lost its build failure.

The mmc tree gained a build failure so I used the version from
next-20110707.

The security-testing tree gained a build failure that I have left.

The gpio tree gained conflicts against the i.MX tree.

The tip tree gained a conflict against the of-pci tree.

The rcu tree gained a conflict agains the ext4 tree.

The staging tree lost its build failure but gained conflicts agains the
trivial and v4l-dvb trees and another 2 build failures so I have used the
version from next-20110707.

The akpm tree lost its build failures.  I have rmeoved one patch (that is
included elsewhere) and added 2 patches to my copy of the akpm tree.

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

We are up to 195 trees (counting Linus' and 28 trees of patches pending
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

--Signature=_Sun__17_Jul_2011_00_08_15_+1000_a8nom66A1=ARShtk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIZtPAAoJEDMEi1NhKgbsLSUH/1fnP4ul/JuPUMNlG6haI+tQ
Gu+e/My/DYd/IWzcvzFEc/c+Vy5+24JfHCC14WKrJpjgMjhfctFYeOZjJUAn/7az
nOit+Ds4O7yTfp8dyFNFoav6LYQDshLqaqDpyjGMYd6GlKGs3klYx5SoMFaiM7Lh
eY3JkU2QkQm+gKrAztHqKnNsjJYSnVdVS2R82fBBO0E+97Zx5B5hFhwxIWSH8f44
GNWuVfe3cQ+R7eZc0tCKw4ncrmlIT8gBXu4tKHmlyyRNay4IUpaB6AwgIielqgvL
kEONWgD7XwQy/4+mksGHfaBRrolnv9vAOuUC1JEBJIqhCKqMoPLDOVityzlRtV0=
=5egf
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Jul_2011_00_08_15_+1000_a8nom66A1=ARShtk--
