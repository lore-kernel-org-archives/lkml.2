Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2EVEuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:50:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44424 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2EVEus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:50:48 -0400
Date: Tue, 22 May 2012 14:50:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
        Masanari Iida <standby24x7@gmail.com>
Subject: linux-next: manual merge of the trivial tree with the mips tree
Message-Id: <20120522145041.67536df96e34135fd802fd2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_14_50_41_+1000_iRxLA.0n9lwq=7Wq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_14_50_41_+1000_iRxLA.0n9lwq=7Wq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/mips/pci/pci-lantiq.c between commit 57c8cb8f2429 ("MIPS: pci:
convert lantiq driver to OF") from the mips tree and commit 6997991ab0db
("mips: Fix printk typos in arc/mips") from the trivial tree.

The former did the fix from the latter as a side effect so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_14_50_41_+1000_iRxLA.0n9lwq=7Wq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuxshAAoJEECxmPOUX5FEsaoP/jg4tAgajgt5DwA9k6juQwDa
tPL5y+/rNI0nA1DMmCdQo4Ac3Mx1WTwJC97y8pYhj9SU17AwZk9aLCKXQDuuZWg7
xBYsULa63unEdi5/4UrzxYfwnfF6L6dSBBQ6b9gTwy2RIeSr3hiYE+6st6Sca+68
8saZoXQx9t7evzmG0ED1mzX6cG51khoOauuA3BRdFeuf/muOwk3OLLTmfcI9Y/Ob
cG6Oo217K7HBUXljys/EM23fwnfGdgFfPWGD87XcPqXo/HcmBSU2kEMlb8brkA3h
cNjTW90M1t4A6Wfdt87ekniXWHiP2RR6pSBsdnPjl4/5MN32laRor/Rpu1pmoVXQ
Ti6CtAgpSEYuOBSoIvkAeQ7wEjWWShH03c8TpZ9x64tYlGgLNNBqZJottpnpt9a8
TgRmlX4OD/Ppd08mH6LU1jb9qJnOd9Etm9CIRrmOYia8jYIdjPj6QVU45t4UZH8o
JPH/55LNwcUZqPPH87/DqmyAzq39985i93FKckiu4CAHbss1Bg8TIGZmvLrxvUm4
hQbfyA8YNFqfdrlAJfYuPwR3bi0Qq+Lmsne6yTat1jHoPmOIEMCPLeZVoWk7VUa0
J3kC7pBaIxYz/sNyMXPtBs0xq6JAF68uUnWHxMVPFSx6qbpe/DqXDWrbRaKuYU9i
1DlTlfDH2Q9iTv2T+sxu
=R2Gj
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_14_50_41_+1000_iRxLA.0n9lwq=7Wq--
