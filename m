Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1AJBKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 20:10:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60735 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1AJBKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 20:10:11 -0500
Date: Mon, 10 Jan 2011 12:10:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the ext4 tree
Message-Id: <20110110121005.3421befb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Jan_2011_12_10_05_+1100_F+OgkEr0KJO+Gl1K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Jan_2011_12_10_05_+1100_F+OgkEr0KJO+Gl1K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

After merging the ext4 tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/ext4/resize.c: In function 'add_new_gdb':
fs/ext4/resize.c:506: warning: label 'exit_primary' defined but not used

Introduced by commit d7faaebaaad6fb5e1fd0b133102817ded5cdec61 ("ext4: add
error checking to calls to ext4_handle_dirty_metadata()").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Jan_2011_12_10_05_+1100_F+OgkEr0KJO+Gl1K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNKlxtAAoJEDMEi1NhKgbsgAMH/1nsHJk/R3QCyQqOxNJ/5CJ0
/fcEHIoiRTLq/S54yHZi9/cUP6xJ0pq8fqd27k3r4HG0aqFqz1G18wvtYkRbajKb
6B1n0GVqTL56HykI92ysujdMSsB0r2RU/yz/xDjm1IeQuxbLlfl+086aPVNYT0u5
hZ0UAnmfZeGh8eEYr4hJDHjIk37jcXFcyg+LEQMV/4vfaGF6Rc0vIvVXJsEd0X6w
+GBW4SYyJBDvYVIbFb0kRWr0zfWTVqI+R8PXvxIciACo9JIhtKvz1HSW4UyLaWBB
dAvoGtcdM9SDZF26SBRlzCH68f0Vy1ae4uL7AwJLs+V0DpmPbv7zLiIfS2Qfsfc=
=sINe
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Jan_2011_12_10_05_+1100_F+OgkEr0KJO+Gl1K--
