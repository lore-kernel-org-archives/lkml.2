Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab0JYD6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 23:58:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55617 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0JYD6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 23:58:52 -0400
Date: Mon, 25 Oct 2010 14:58:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 25
Message-Id: <20101025145834.9b68e026.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_14_58_34_+1100_QXteZsSW1c8eHnTV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_14_58_34_+1100_QXteZsSW1c8eHnTV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Reminder: do not add 2.6.38 destined stuff to linux-next until after
2.6.37-rc1 is released.

Changes since 20101022:

The net-current tree gained a build failure for which I applied a patch.

The tegra tree lost its conflicts.

The powerpc tree lost its conflict.

The kvm tree lost its conflict.

The net tree lost its conflicts.

The crypto tree lost its conflict.

The block tree lost its conflict.

The mmc tree gained a build failure so I used the version from 20101022.

The slab tree lost its conflict.

The trivial lost its conflict.

The i7core_edac lost its conflict.

The tip tree lost its conflicts.

The xen tree lost its complex conflict against the tip tree, but gained a
build failure, so I used the version from next-20101021.

The percpu tree lost its conflicts.

The workqueue tree lost its conflict.

The bkl-trivial tree lost its conflicts.

The bkl-llseek tree lost its conflicts.

The bkl-vfs tree lost its conflicts.

The bkl-config tree lost its conflict.

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

We are up to 177 trees (counting Linus' and 22 trees of patches pending
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

--Signature=_Mon__25_Oct_2010_14_58_34_+1100_QXteZsSW1c8eHnTV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxQBqAAoJEDMEi1NhKgbsPF0H/jRbI4I85EtbfGUJplGteguN
41vg1SBkaHb7M7CkHJu/Sj7Ucdzf0f1LzyfaT5MekgIVrxvyJnlf14puOQhjOdGE
FtgGJxSYTibHu9GquyK3as03eKROCDnyoPlLntTv0mdBjtdGI0ZRYmVlGdfvTs6y
XX51nPXvusN47rYkXePdFFHE3ula3eEitoIvf2DdCO91MNmMVFsUylDGfLZ+HBfe
24K2jn6fmUhRGQwdER7nlXc8wNa227n/u8uhl7w3VqrYg+GY+204Ok6yYJJYMC6H
jHmzDzb9KRi2vSPOJeg4H4Ba4AaYYAQ2kKz8wn7UGx/1fniiL/JWsCoGkLjNkcE=
=t+TA
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_14_58_34_+1100_QXteZsSW1c8eHnTV--
