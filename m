Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1AQBOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:14:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56571 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1AQBOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:14:52 -0500
Date: Mon, 17 Jan 2011 12:14:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for January 17
Message-Id: <20110117121444.24452592.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_Jan_2011_12_14_44_+1100_X3vadKChVdc_a/Ib"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jan_2011_12_14_44_+1100_X3vadKChVdc_a/Ib
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Reminder: do not add any v2.6.39 material to your linux-next included
trees until after v2.6.38-rc1 is released.

Changes since 20110115:

Dropped tree: xen

Linus' tree lost its build failures.

The bjdooks-i2c tree gained a conflict against Linus' tree.

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

We are up to 184 trees (counting Linus' and 26 trees of patches pending
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

--Signature=_Mon__17_Jan_2011_12_14_44_+1100_X3vadKChVdc_a/Ib
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNM5gEAAoJEDMEi1NhKgbs+hYIAIUXLGYtbaSUnCSNs5WQuvR1
V+2d8A7AKYSgRAwFkmwOsBc7XN7s3OoF44CpVQBID7GXaYgJobASqVjGBm5yHrnD
c0gWBCCBamVnVNlwWQpsUfWQmms3EhcPzBi9r44FVxIfeI2LZYJ0jh6tISjK888w
0IpRBpivNxumBpfxGgKm8Z9trHH6JDVh3X3F2ouwarEATn0qqQxRzTaQ6l8fgDxk
Z+VBl0lnpkYshaFI4+y5vYV3BBtQruGnvzcGrvBtq7ZbZEWC1IEAwpvGyuryzpZ/
Ggy7tkhBE8jaHKEe+YTMXYRRDP9m4WZOTRB0iq46xIvf8Mgq/vYfcHj0BB7QYR4=
=wL6I
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jan_2011_12_14_44_+1100_X3vadKChVdc_a/Ib--
