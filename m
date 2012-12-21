Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2LUCmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:42:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53730 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2LUCmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:42:16 -0500
Date: Fri, 21 Dec 2012 13:42:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20121221134214.456d97d43402481a38e12023@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Dec_2012_13_42_14_+1100_D7/5bskR=nKEV2=V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Dec_2012_13_42_14_+1100_D7/5bskR=nKEV2=V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/m32r/include/asm/signal.h between commit f7f4dc10e1eb ("UAPI:
(Scripted) Disintegrate arch/m32r/include/asm") from Linus' tree and
commit 031b6566983a ("unify SS_ONSTACK/SS_DISABLE definitions") from the
signal tree.

I just used the former version, but removed the SS_* constants from the
uap version of the include files as well and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Dec_2012_13_42_14_+1100_D7/5bskR=nKEV2=V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ08yGAAoJEECxmPOUX5FEm9sP/Atke9WHGf8EkbV0IAHmvLwp
CPfQNiNob1QmH3f1ZgBKtPth6YxTeAjFWHdrbgGw1njpMzBbmrVbInk2KJecEI86
fVhedDFe/qlznSCJ8Aatzf82GJ0rNFdZ/+9HJ7SzWpUh1MM1uxKoHLY3njmSd956
Nyf/HLe1sLAHIGFJtXa5OAQIwVhOZoTEn1AEbhn1r3N733C+wQByIALuQZRTv6Sk
NwQH0vVD3fSJCZopPWgJQ6vCKxPP/5ysXJZVZzpayKcfxHIevByR6tiNiDsNm02M
cBln6Db11ZtDaEC3TCveDgIO+hjz3Tw4F2V/TbELb1AoyCh/qyEa91yBuydBY6wc
fPf7/7qCa2aFcWBvJoth0TXWQFjy5k94/DNKPsbVvopCHwfwRdJGfHhxW4RP2kg5
JK0sigX3sjodSyZW1p/luMqdb1e0bZsXUmoJxRyI0wU/dcL162Xgdw9qkSB3IIbT
eHHygNzuDuiKhsStVO+hP74Ih4EKFlyca1ikj6YjmnVZzqZGgZdi7A4LM4P9K21B
wznKcHb7HjMlvAMX+HMWKJru+5tXbrdBM187TJhXoCV5Rjp8Vrut8yc/I7arjr2Q
/55MQO4P8OpoWqG3JPYFVn9LQb9XDZsMVL50ME7Fer95LIDlWX9JctuPxyJf+ps/
6uxEBHwFclqTf+2jXu82
=DnDE
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Dec_2012_13_42_14_+1100_D7/5bskR=nKEV2=V--
