Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030376Ab2CUBkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:40:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47155 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2CUBkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:40:17 -0400
Date: Wed, 21 Mar 2012 12:40:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Durgin <josh.durgin@dreamhost.com>,
        Alex Elder <elder@dreamhost.com>
Subject: linux-next: build failure after merge of the ceph tree
Message-Id: <20120321124007.e879c834619c7bb9298d5694@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_12_40_07_+1100_PI/b3PfWS986Rpiz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_12_40_07_+1100_PI/b3PfWS986Rpiz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

After merging the ceph tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/block/rbd.c: In function 'rbd_add':
drivers/block/rbd.c:2384:2: error: 'struct rbd_image_header' has no member =
named 'snap_rwsem'

Caused by commit dd2a081fb58f ("rbd: move snap_rwsem to the device,
rename to header_rwsem") interacting with commit 0e805a1d8577 ("rbd:
initialize snap_rwsem in rbd_add()") from Linus' tree.

I used the ceph tree from next-20120320 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Mar_2012_12_40_07_+1100_PI/b3PfWS986Rpiz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaTF3AAoJEECxmPOUX5FEo8cP/0tAyD815UX3gg90B34tubfJ
qq7DPnZiW9gPw7hlgN/ZKcN2eQDjpocj9PQWNvf6gihlleYulTJvqPFBSLR71VlI
URLi0VD9c4VIRhxPVXmY0hp5vzJqrGquYwgxesYkcJ65vfT26VJjP1AK48p6YLQd
KQME7kfqtKPSzc9vk7vEGF4xPRTQmVQNIb6CS3AODw5bv9n5pfYWihgGWWAXq5+i
qrdsu/fdkzr+yVXtE6gRE1IWgwLcuYZ29JN6YC3+wVMPALAp6NbYMsJq1exxTi0q
13NEXMuKc6bxxN0duM/R7TLFBb+lRqoxYbAR/ti5QVQeejU0shS+mD5OlfniXkE0
gMPndZQrnxR44nQiW0FyIN7uQVdcbJ0giIBU88dZlpgr7yqwZcpoZw1TDZYgZxJ5
hNNbPuo8ok8pJTr6OWjnROVtP6HI87NpSQK1niWcYfhCq9P2dfefbClHlIWZDec0
xAHhevJ2VCHX9emUz7gfsVp9ZL1BvaiTTfwsFVtKGzB9zwiBDeETM2JfmrbJrHCK
uFCw0Vb0hlc4PKwP5ooWFxSmfqiGzqtDNjoQ86WQUyKQaF4TzpViQZp2ocO8GOO4
ZVGuMVKkMWEM0gA9v64vEJv9lOfqt+75bprXXLRPAYd9sgcM7H7uJ0fkf+C1l+Kr
hATlp1RUXvna7xAr505Z
=TOIM
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_12_40_07_+1100_PI/b3PfWS986Rpiz--
