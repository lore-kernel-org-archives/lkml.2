Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2GCFuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 01:50:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46775 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2GCFuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 01:50:39 -0400
Date: Tue, 3 Jul 2012 15:50:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 3
Message-Id: <20120703155037.998191dc7de2a7a9bd993ea8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_15_50_37_+1000_=L155V0pXkGqlkdf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_15_50_37_+1000_=L155V0pXkGqlkdf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20120702:

New tree: clk

The net-next tree gained a conflict against the wireless tree.

The usb tree gained a conflict against the mfd tree.

The pwm tree still has its build failure which I have left broken for now.

The akpm tree lost a patch that turned up elsewhere.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
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
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 192 trees (counting Linus' and 26 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Jul_2012_15_50_37_+1000_=L155V0pXkGqlkdf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8ogtAAoJEECxmPOUX5FEu1gP/Au1z2O6cF1qAimy6SD2jocS
heik7CoxHaYy5qfsun2bEC6UYaC7HrkLM7kP1rbd4e1IslVIK/o9x8HwmjksJCGI
ym6d32uCV0c9P6mR+x+e8ASHIhrLNJwX0uUzN1WP0PxclB1RBMOzPhg3/gZHlHjN
WacAsYHSKvkyIzhL3zikXHaj1qz2Lc7ALFpo7327Hy0CTHxh7enGRC4/Mgt/Pg/T
XTRzj98cI+PKZw2QqPvZS+PyKf5B8zlnUY9ovrdpy8JAVcFOuY5AB3wXn7MkAFqD
6OtMtPYG00mH3NS9/pmiisUeAZe3jozo4S93JoFkreiinleSoOb0qt3V/umx5o5n
cHqFWUeGzwwTIUOeJdIc63ENM/7SJS6JomY6Yanyov3sGpsKOFVxbrsymwHmDe/i
hn57dK+CC7CZUComz0pRzcVinJFPf7A5pkfSSfhM8NThQnfFxFEPBX9XPO68X47/
6L+UhCN6dgjQR9Vkj+GscGra3hwmwe5gJKb8VvqxDeHxUs4cpA6chFkT07squmrK
9lKSnhugwfGlBC9fHtNpUzejTjJt08963ogjf6zklROV3gIDhvTarmkkPfta3gVp
cFAjyVccg4PznA92spzLLqOTUw4KQHva3JTKTHXmqZIP5kpKDpMFfZkSGAV6B0YG
5bg7PumSxtXVmRUMriua
=5ox9
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_15_50_37_+1000_=L155V0pXkGqlkdf--
