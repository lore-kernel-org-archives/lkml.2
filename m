Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252Ab2FEA6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:58:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60302 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2FEA6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:58:10 -0400
Date: Tue, 5 Jun 2012 10:58:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: time to clean up your trees
Message-Id: <20120605105800.2eb191827746587cbdb60d14@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Jun_2012_10_58_00_+1000_T75PT8tZk=48pvfk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jun_2012_10_58_00_+1000_T75PT8tZk=48pvfk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Now that the merge window has closed, please clean up your linux-next
included) trees to reflect what is actually in Linus' tree.   This
especially applies to those who rebased/rewrote their trees before asking
Linus to merge them (and the quilt series).

If you have already done that, then you have my thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Jun_2012_10_58_00_+1000_T75PT8tZk=48pvfk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzVmYAAoJEECxmPOUX5FEGMoP/1jSI4FJ4h9sg4NUH2p/oQec
ewtisJc+fLiobn3MDKG+DBkM3mABQn7Ctx6Pf3JBg3CeBsxDdP7hRiz6KDcmUyBB
s225nq2xXjwKAJHdHd8zUiy1v/+J0cl+Pe0pWvhe0Q1yS9Ti3pqBQHQsM8XD3rV8
tX8zN10Xyu7X6bvp8fEzymaCx7FOCs5rcnCNyOGit4P1WkAp6rlCoIGgr2zfkqPn
PDIkNBvpqRaytXHsUUCV2nukQlcCydBclZE4JI8NLnOtNvTR65GCgP62o7ihQCwU
yAU0rh7OTc+gylcDHL8YfHGH94Cys/b23NhScV6fQFWOE2wdwwPvsW/kilkdrkwj
czr0Mkd/2FX7zty8ppBeVBQQxBsraGqGdF+wq4suR/sED8Wx8KQJLlptE7KFi9fC
gjz0eMIcTJNmOBBe+jeoccpTOPMFTT4Ozj1zsLzlKT4Hr4Ml3tjKrNRSZVOpjh72
vFTi65LwEb5l3KfFgeM7V+g1knZHUM00q4Jrd8wWZtdJCgKlx8G5mrVnklFZP2io
BARqxuWJKXrUZbRvdPbZubuy9R3YTK8iEqLmhHx2QBlTzf5tw+zIiSKPVJNWDqoA
kkgF4/Gs0tc+tC11YvFm/bKOpJwbwrbZFe3YAaBUrddLt8sku021Mz2tNxJAIQiN
+MvlkSY6PrXYS+NzXHpi
=D5EU
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jun_2012_10_58_00_+1000_T75PT8tZk=48pvfk--
