Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1LABC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:02:29 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51925 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab1LABC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:02:28 -0500
Date: Thu, 1 Dec 2011 12:02:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: build failure after merge of the v9fs tree
Message-Id: <20111201120215.4320090bef1da653abad3392@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Dec_2011_12_02_15_+1100_wh492BBl=gaUqd5L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Dec_2011_12_02_15_+1100_wh492BBl=gaUqd5L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the v9fs tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "_p9_debug" [net/9p/9pnet_virtio.ko] undefined!
ERROR: "_p9_debug" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "_p9_debug" [net/9p/9pnet.ko] undefined!

Caused by commit be9e4aa9e783 ("9p: Reduce object size with
CONFIG_NET_9P_DEBUG").

I have used the v9fs tree from next-20111130 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Dec_2011_12_02_15_+1100_wh492BBl=gaUqd5L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1tIXAAoJEECxmPOUX5FEzBIP/i5mZjfVBh0dkl9CULdvw65W
qzu0qwzfhHA42BWWF78Mea3IwHmkKo0n4GQEFZl/pQ2oU1hOyG8YGZt+QbpDCno/
7HXMS+YI+0IlcmT/eJa/C+ePkHa+t2S/vHoHp2MiW4xpGPuTc4vUIyWczJy6keHg
TAqNMLObgNBVj76dXiwyvhIb+0oNMOd5lNmnpJjH9Cp+QXIuI1W7U69joWidPLMJ
WIOk5YT0QhWYbf/IrzBTKbJ29zxjODACQjVi4T/+2e+NF3D4+2ZR07xOkg9xN/8k
DE5QthVt2/Xm097EV8dbVg/W73J4bo5JZuJoN12jXHkzUVdjVTET9cfAm4j81Kw+
exWgHFeXUiTD1r2ZTvfIQRVdOOJbA1nDOA0xCqOgLzm18JBz7Bpf/DeihpzwegVL
O+eky7LGdMzKvAXZecy+uzBQaXe0YrlH0kTM2MOe0Ev7E3z3hrYdlijfTOBxtcIe
Xg3NfMhwVCnalFx6OudObxrkrNVKgcC0nsx0HH/s/xzIjkX/lUGHepxUBhx/e1pN
FzuHrwI1XDq+Z6gEoZeRQm35h751+YJv/ImOydZLZMzsDk0UeYXSQjkif2yqk0V0
+9Y7TnBFdFT7q8leJCmMBzvoIgedAVK7nWmubykpVHBduk4Tx1/t4yAbsQgBnj/K
oUgB1bEaKw4q5x1F+P4u
=zdCI
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Dec_2011_12_02_15_+1100_wh492BBl=gaUqd5L--
