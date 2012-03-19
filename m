Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2CSHjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:39:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60210 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2CSHjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:39:19 -0400
Date: Mon, 19 Mar 2012 18:39:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the arm-soc tree
Message-Id: <20120319183911.0cd46df560c714ee71184242@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_18_39_11_+1100_HGvPfZyBByRP.6v6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_18_39_11_+1100_HGvPfZyBByRP.6v6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the arm-soc tree, today's linux-next build (all)
produced this warning:

drivers/clk/Kconfig:22: warning: menuconfig statement without prompt

Introduced by commit c173033d154e ("clk: make CONFIG_COMMON_CLK invisible").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Mar_2012_18_39_11_+1100_HGvPfZyBByRP.6v6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZuKfAAoJEECxmPOUX5FEiEwP/1gU/qpGpgQTEwA2dOX0nLob
d25bJxWe47v4FZBwDneGmymyULfWxE9K64sDGig9yNbNfrpB+/Fo9zjS2gbA2gI1
j2DT9tqeT71d53fRAlI7mwFPylxUUzg6G1TUhs+3htIniTkzEwp73m4+1zX9oRNZ
mT0dcItKcI+2jRkq4N0pxeFkbrx/Rcf1yokkLsX/V4zYGZqQLvlvqD7BGPn655eP
ON7R5vzPyoj1kpaQobbg7Qi70J0Q3cWH++IlYAUvBWmMQ4SLktPcCxn/a/qO4PZe
1PgsxXSmvPPp9lvuOy9/M+CQmnHg2bLvPvRQyHawH0YHtbEWhsx2g7i+JaMvZXqO
MLpAzXHya86qOxMoQK2fi00EuiZGSzgpvc/Nqxg7XBd6HcA/4Qy8BCNVSXJB+eFH
udIKpeDM59p8Oe+cZh4UopmkxAPIFhu7bLxmNZiFOAv1t9um3O7I6T/l2aS0POoy
Y1T7A37Vs632EyAyz9tNL5fF5ACsV4zZ2h9gqwHCqtWiLC9IrBLWdnVDzbjPHIW7
6rIa1IaP7OjY7TnK2M5IgVrCTVkkWKgMG3bl+WZFh+xvmYbI5R1UMk7oX4k87cmn
rxVN2mYrq/LPb5GmFNTpuR9CKUTb4HSpxpACV3RPUz8N/kOh+IuElpOghD/HLzLd
6VhfOmSTe8o9QQzABmeK
=lynW
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_18_39_11_+1100_HGvPfZyBByRP.6v6--
