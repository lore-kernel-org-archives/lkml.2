Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2JLD6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:58:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57069 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2JLD6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:58:46 -0400
Date: Fri, 12 Oct 2012 14:58:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20121012145845.0c55e327fe52315a64a15a64@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_14_58_45_+1100_grJEN50iY2Vkmk4_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_14_58_45_+1100_grJEN50iY2Vkmk4_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/frv/kernel/process.c between commit 2a5e5beb88c5 ("vfs: define
struct filename and have getname() return it") from the vfs tree and
commit 460dabab73f2 ("frv: switch to generic sys_execve()") from the
signal tree.

The latter removed the function updated by the former, so I just did that
and can carry the fix as necessary (no action is required).


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Oct_2012_14_58_45_+1100_grJEN50iY2Vkmk4_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd5V1AAoJEECxmPOUX5FElmgP/1KbGxUo5S7u4s6oBve+nWCq
HwLZMbYy6bDlfXqo242HkbKXZ8ca9yie8wwcK8YcYlphM71ZC/KXCgQ7pOrl3SmV
uYeXwk3xPxiJ/jskoutUCPs4kgP4u7ySXzNMVx1CWtINwRk8Oi0DHjccmdj/oRVR
5nZfO5PUBuixMyqhoYgmFPulXg91Y2nmvDux7YIE5ifUbsewkdIacgOr9tOm4Z7S
qCncz2o4J9YTml6RoBR9EtjPOezVD/nt++L1exeQTzcLZMiv/md6T7LH7XYMLLJ5
mHFJruRzUKoSkeyG4XzKzN/6qVBrAMBhlMAEdbq6CcMUTfPBuEyp8S37e5pRkKb+
28m/OoVjZlIorNmicNIpuC0Fks51Ero+Ge6NVJR6CJ92oMkCcwyfvD2FZo6sbazv
tsZA9L/q0xNq757XrN8/6HlsAuigIuF4L5PkUVgBQn1JjhP3yxTwVmUxJM6ay4PB
J8VA/0aUyKVcZbawC+QgGZMgKs7JA8huVyQbaJnYUTwH9aVieol3f2i0qRNl3ORc
6bAtgj4M6JeBxAxH+mux8HM3frjhTVgmaF5NivAO431bvVd+flCwVnSwInuOhe50
K66kCK7zv27FoSylV/sB5qtDqGDy55cUi2Tt3PXtwl5M+U9Tmkm+5rpJR4zUUq6c
RLFL3AqFV5kT1edz5E/G
=weZd
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_14_58_45_+1100_grJEN50iY2Vkmk4_--
