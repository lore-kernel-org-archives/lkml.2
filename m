Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2INFey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:34:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37114 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2INFev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:34:51 -0400
Date: Fri, 14 Sep 2012 15:34:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Karsten Keil <keil@b1-systems.de>
Subject: linux-next: manual merge of the workqueues tree with the net tree
Message-Id: <20120914153441.8710c191199ceaff4741a834@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Sep_2012_15_34_41_+1000_pf=zdDtbNLuqJH7h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Sep_2012_15_34_41_+1000_pf=zdDtbNLuqJH7h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
drivers/isdn/mISDN/hwchannel.c between commit 4b921eda5336 ("mISDN: Fix
wrong usage of flush_work_sync while holding locks") from the  tree and
commit 43829731dd37 ("workqueue: deprecate flush[_delayed]_work_sync()")
from the workqueues tree.

The former supercedes the latter (I think) so I used that and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Sep_2012_15_34_41_+1000_pf=zdDtbNLuqJH7h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUsHxAAoJEECxmPOUX5FE/BwP/2IPm5UTuTmJXJqOarbI8qi8
8FAjY82h0VKKD7LnxUDQK0yL2sAdiymA2rH1J9+t0hR9iRnZNo/+fGm21ZNfUrK2
wwSlKGo3Hh5Yo/CCycMMgmfcB9WD5VKatIi83khoHXoAWohZDLbAjnZapeGnbmUI
Wtb9Kx63acrLoxyJd0z/rG5OFaWiP3NRA0Uu2c48E+gtwLx+Fs6QQtHPZb5DUrWW
ZXAP6osYfRY8R2pHOzgL/l0mbG2UkvuuFhXP/NqNfadalbXd6Xt98A5I6JjHU2/7
roe14+n+usxB+dwSvqP9msZSdP2OwLfaC3xD9I2ubY/laAgdahu4b1aoxfqZ612w
SKvqJYDvgLh/z0WxmQ69MghGUylNftyrzHTKVfG5bamD8kuoW2u88jkaFO3qSYgn
2b84qcZ694oFROaBCWXe1s5CNlI2j//ye+Njg8bgxx+8JwIbdYBaFmsBML2kTbXy
43dUe/XmKtc3T8lFLrM0qBE2rb2H0AAgCURa8vii6vvJNDndjLryDBfGmkZ/e+7P
ZeaJVKeCzNtlqSi2lMEXVhwP/68sIZGM+ik3tCSvmc9QU8e0o9Bp+LOL8BhZGdca
TTY2Py8m50GQKB3VFNdx/Lh2qbRBEoryRRoFZvEPm3+4WPmUBpbXdjImj0sb1Qv9
elCHDlW/DY9rBQfah3pE
=waV0
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Sep_2012_15_34_41_+1000_pf=zdDtbNLuqJH7h--
