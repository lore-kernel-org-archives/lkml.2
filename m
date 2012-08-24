Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2HXBet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:34:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48833 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2HXBer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:34:47 -0400
Date: Fri, 24 Aug 2012 11:34:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ubi tree
Message-Id: <20120824113439.6fdb432e7d6057b3fae27d3f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Aug_2012_11_34_39_+1000_vtrj1iM6.J=rgMAL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Aug_2012_11_34_39_+1000_vtrj1iM6.J=rgMAL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the ubi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mtd/ubi/build.c: In function 'io_init':
drivers/mtd/ubi/build.c:658:3: error: 'mtd' undeclared (first use in this f=
unction)

Caused by commit 8eb71060a0a5 ("UBI: disallow max_beb_per1024 on NOR flash"=
).

I have used the ubi tree from next-20120823 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Aug_2012_11_34_39_+1000_vtrj1iM6.J=rgMAL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNtovAAoJEECxmPOUX5FELAkQAKM196Vf4D3uX4vSQflsC4pn
4vy35xrO0faXHUG8VMI1/Gc26nTehWWZLldcQujNi9sfZBgNMFrHBPP9q/E7yLxv
Fmky8o53clMUqbDGN1JeW8Be7HXq4GAx98xclC8XmxTd5EYIx6aRSv+9Enr2vpoR
uXvB6LcTY3SGonTWg78eYrrOx+xuYJ8aRqbTvpbip0/l4oZZEF/u68lHusVtnrFA
FE7FpIHYhth+C60z5HTl2M0chrh++mJGPvY20XOiSDdCLIAXtaUH/zx+xMMmBb63
i1Tq97G8YkRf2tRMYMs3wrhZrVUNmkY7qZIjMnzonTthwKz+9NpZu1IAGWzU04+6
1IVNRIg2W6am/6VYPQml3DAMgf2O7M4wPBuDp69SIYVI20Rne0MgBdgg0IbC/Kjj
MNDJzBDkvxdvRG9ajLLOui2URSvP4Cd9Qav9cLPAfbIaHbDqL3WPJSeZweo4EMVE
XkUPwxFF8Oe0gKr+jHP9WkJ3ZwdURzxYMwT809Nklf2AMLQxk0/+MgJS4U/CMEeZ
l9lW2aUMiP7doBXCJ2eHR0jm1iPNCz6SmG2kxZA9smg6xZvjrh5AGGegsEixV33P
8A4BEX/CCxcpTBs5aNlZXh2gliQxszxvpQF+32C1t+puyGEAHJXt+t/BdpTTc5Vi
yflu1F1b+Mk4IfIYdJgn
=gwV7
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Aug_2012_11_34_39_+1000_vtrj1iM6.J=rgMAL--
