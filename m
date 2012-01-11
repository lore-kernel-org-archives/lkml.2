Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab2AKCcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 21:32:01 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53026 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2AKCb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 21:31:59 -0500
Date: Wed, 11 Jan 2012 13:31:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
Message-Id: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Jan_2012_13_31_46_+1100_c58BTM0b/TJ0jKTZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jan_2012_13_31_46_+1100_c58BTM0b/TJ0jKTZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got conflicts in a large
number of files between commits from the arm-soc tree and commits from the
v4l-dvb tree.  You have rebased the v4l-dvb tree onto v3.2 while the
arm-soc tree had merged a previous version. you have then added a lot
more commits on top of the result - which produces all the conflicts.  :-(

This is exactly the sort of pain I alluded to when I first noted that the
v4l-dvb tree had been merged into the arm-soc tree ...

Not happy.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Jan_2012_13_31_46_+1100_c58BTM0b/TJ0jKTZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDPSSAAoJEECxmPOUX5FEa1kP/iAIybu/OWiYiYa4HI00YKUL
lZvR27u/GPmPoQ2SEjQziVHOJJDcIvlK4hkh1paworC45wZlhMitIm1YKsAsDd8s
XBSRNF1RNOojzGs+u710GLsRXl/1tjalTZI8GttJM9YeYf9yN7V5X6oEQcWy7Gpo
AqCBqRt8DzKN/x+ecoGC84YLZoeBNlg8waCHy6yAdxPI8b2hHlrhDmUNmf/lr5rC
uE4vrd30n4UCajXFXxwKAHj/l2Q2cVL4pwUYeSmjVpQKm694ltni8MtSD28+jag0
ZK5vK/BNHrLpEhOSLsLiT8Mjb2G6KzIooR0GKRnlEayWZNMUN07IEJdvM2m6C/lP
z5yxB8QfyIdm4KhlXC6YCrqUsjG3VAZnpI2qMfwbk0+N5hjbXdm/YvYBrQk5Aq3z
i3oDDn7xA93d2/+x3ke0BYYGKIQwKXca+yYA5E2wBLmJRXoYQTNdKzRMgO1ExTgP
JjbKwTw75bFKHS5BUs6a//a4oucpEkS+8H6EvixiLmjMGDK7nhz/ytg694+kmt7S
tqPdlJPmiKRVRO/MkcZeiocsmqDWtc2erWEjjAK9yMm/IFcIPvxohoWIONJ5s70n
UMISIGXvvivIfRxs8osch1XeTIdlxYQg4bvmXP4cpUqqIf5Nvq8gi4zw56TZaUrr
Fc0huhNzVAtQj6cv7Qxz
=AqZa
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jan_2012_13_31_46_+1100_c58BTM0b/TJ0jKTZ--
