Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0IWBE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:04:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55947 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0IWBE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:04:56 -0400
Date: Thu, 23 Sep 2010 11:04:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20100923110452.70c5e572.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_11_04_52_+1000_8t0C85JHXj7Xs935"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_11_04_52_+1000_8t0C85JHXj7Xs935
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/pagelist.c between commit
3d4401d9d0aef5c40706350685ddea3df6708496 ("ceph: fix pagelist kunmap
tail") from Linus' tree and commit
49dde0c8bee346a349862c4a3eddcd58e0d0ae90 ("ceph: factor out libceph from
Ceph file system") from the ceph tree.

The latter moved the file to net/ceph/pagelist.c, and the former patch
has been applied there, so I just removed the fs/ceph version of the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_11_04_52_+1000_8t0C85JHXj7Xs935
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmqe0AAoJEDMEi1NhKgbsFeMH/jGt4bj31QGGc1d62Fsiu/JS
UezrK/sFal+CMdHhJYfrk9OhLlHvq6U95lCB9OSeX6ItinE/DxHvr06q7or8xyph
LnxK5HWEG0oi4Fwfrv3Zm0v4yQadx5Vp9xjgADV1sv7/eEeml21EJj0lR7mKXNVj
Qt262Ps9Rok6uF9MbYA5fGeaZ0YTqekU2cfHtjP8MlxeCNALk/JG4C4T436RdiRv
BbF5RTX7xX3FO67pfxeW2zvp0zNIxohJ49XlY2GlJjmG99b4whh6moV59LNEant9
JtO9qp4e4znnEiLcnRH7TyzktWo2jmu/9AJ10movRpxY/PWReJ7ud3/sc5M0WGU=
=rEKs
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_11_04_52_+1000_8t0C85JHXj7Xs935--
