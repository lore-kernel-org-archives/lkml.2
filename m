Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0HPFEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 01:04:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49265 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0HPFEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 01:04:31 -0400
Date: Mon, 16 Aug 2010 15:04:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 16
Message-Id: <20100816150420.7f3f8cfd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Aug_2010_15_04_20_+1000_tX48TE4HkYmiwSWO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Aug_2010_15_04_20_+1000_tX48TE4HkYmiwSWO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

As the merge window has closed, let the flood commence. :-)

Changes since 20100813:

New tree; florian-viafb

My fixes tree contains:
	spi: update for of_device to platform_device replacement

The sh tree gained a conflict against Linus' tree.

The ocfs2 tree lost its conflict.

The v4l-dvb tree lost its conflicts.

The acpi tree lost its build failure.

The rr tree lost its conflicts.

The alacrity tree gained a conflict against Linus' tree.

The spi tree lost its conflict.

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

We are up to 170 trees (counting Linus' and 22 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Aug_2010_15_04_20_+1000_tX48TE4HkYmiwSWO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMaMbUAAoJEDMEi1NhKgbs4KoH/ijVeDab1U2CjGAF3g52ZsUC
IbaYgTql40BIBq9HtHWmgqvH5gYTnz4GoXYTISo+qvcbNibleHnTfBW2x0B9eVVR
wB7GjZYdZlwn0MPbRxBzbjv9h+1r0nHjNe7Rrv6lUC22vDEy8mO2qd7amCbgPRae
DzWx8xsKFP0PZq9IENwWDuHSk5OWNxRd1mtzbjaE78S7nykyqepGazHh2mLy3eCA
7H/iBCaN24hj/PkiQpjgy2JZHI/8ZRlNDvc5aWAKam0VfBZidD3MzltiqTMUD+tz
bVXvxeXUiSF8pWBcjUGILRz0H5N9FSsBBsrM8328MglA/vQK+QGI/LLzWZ3G6Wg=
=SyOa
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Aug_2010_15_04_20_+1000_tX48TE4HkYmiwSWO--
