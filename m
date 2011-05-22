Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1EVIPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 04:15:43 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48935 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab1EVIPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 04:15:34 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Parisc List <linux-parisc@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: PA-RISC: compile error in include/net/dst.h
Date: Sun, 22 May 2011 10:15:19 +0200
Message-ID: <2612811.b2htuyZy9x@donald.sf-tec.de>
User-Agent: KMail/4.6 beta5 (Linux/2.6.37-12-desktop; KDE/4.6.3; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2353673.HFIKzf23yx"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2353673.HFIKzf23yx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

                 from include/net/ipv6.h:16,
                 from include/linux/sunrpc/clnt.h:25,
                 from include/linux/nfs_fs.h:50,
                 from init/do_mounts.c:20:
include/net/dst.h: In function 'dst_hold':
include/net/dst.h:238:2: error: size of unnamed array is negative
In file included from include/linux/nfs_fs.h:59:0,
                 from init/do_mounts.c:20:
include/linux/mempool.h: In function 'mempool_create_kmalloc_pool':
include/linux/mempool.h:58:10: warning: cast to pointer from integer of 
different size

This is both in 2.6.38.6 and 2.6.39, but is not in 2.6.38.4 when compiling for 
my C8000.

pioneer src #  hppa64-unknown-linux-gnu-gcc --version
hppa64-unknown-linux-gnu-gcc (Gentoo 4.5.2 p1.1) 4.5.2

Greetings,

Eike
--nextPart2353673.HFIKzf23yx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3Yxh4ACgkQXKSJPmm5/E6F1wCfdSZOu5ooYpMwgMhXpkeTT5Rk
qVUAn0+WeORQaglK0soXo7T61Cyrg2uU
=ur5h
-----END PGP SIGNATURE-----

--nextPart2353673.HFIKzf23yx--

