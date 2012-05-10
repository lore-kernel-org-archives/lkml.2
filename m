Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2EJIwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:52:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35121 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2EJIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:52:03 -0400
Date: Thu, 10 May 2012 18:51:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the akpm tree with the rr tree
Message-Id: <20120510185155.47d24f37951786b64af97868@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_18_51_55_+1000_ExuL0YBohF4c4v+r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_18_51_55_+1000_ExuL0YBohF4c4v+r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in
kernel/lglock.c, include/linux/lglock.h, fs/namespace.c and fs/internal.h
between various commits from the rr tree and commit "brlocks/lglocks:
cleanups" from the akpm tree.

The akpm tree patch seems to be a merge of the rr tree commits, so I
dropped the akpm tree patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_May_2012_18_51_55_+1000_ExuL0YBohF4c4v+r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq4GrAAoJEECxmPOUX5FE9IcP/RV1InN3UIPk9dfHdm0W+dWl
t+oHZfY0+I2pdinfeR6/wpva9tD6Pl/y2NowNjIPbNO1iqTIimV6yHH5hbeDrLIw
Xih5k7G894wrgF0+P/7I7F7JzyyNoWHWMKB1JynCXTOY1NjySrwwDqHYuCbXn4E7
SKVizz814Uzmril01HXuHZVg88q/52O2C5/1JeaUDUzg/WdhoMuRU5SliTDlQeVi
xdHJOwM0qqq1FdUOTeGjI3Kp2zN0yBeZteUSV7khlr9nWfVJqBipAajUqm2rJA81
ty60/pDm6+JeeUAYxxmHnDMPC5jatrSRRNcBq4L/zdxENj28MAkF5WZ2OCUGTglo
ki/gLfl4zK9Znh2tjGvFATcRM67hjPZ0BA4Nr0rUJsCoVkk09ZzG7VRGD/Gj6X4k
pwlsqCMq9g3qus05E5eZBr2r7hhd2WYeSPHabjrbk+F8X5Sa4ze/KP5ZtoAlaKci
fYXZ+RWAqLXSlZJpJIwTgoVvbUUu4rzazEczkKm0QO6l36nOb9Hsgy1ofvr0J612
2tztYvmeipvKF3qKWkChjThrfbTaD2BlmHCPvPMP3td+SsibkP3s+qcSFagHSHv8
AmH21oqt65P2g6PWFk/HQ8LfiJJrwFRqmINTx2siLxVu6jToW/867LxoQUgxURXH
sMJXZv7OKkD8X9BBWym8
=gMGS
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_18_51_55_+1000_ExuL0YBohF4c4v+r--
