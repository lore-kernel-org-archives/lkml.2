Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314Ab2CSGsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:48:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36624 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CSGsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:48:01 -0400
Date: Mon, 19 Mar 2012 17:47:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20120319174743.aff001d4f84e82cf4042277a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_17_47_43_+1100_3XFqHJ_=PE=pS8cF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_17_47_43_+1100_3XFqHJ_=PE=pS8cF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mtd/nand/atmel_nand.c between commit 4331c79c6895 ("mtd: do not
use plain 0 as NULL") from the l2-mtd tree and commit d6a016616ba8
("atmel/nand: add DT support") from the arm-soc tree.

The latter superceded the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Mar_2012_17_47_43_+1100_3XFqHJ_=PE=pS8cF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZtaPAAoJEECxmPOUX5FEOMAP/1R3KfZ0BnrVmHcV4q5PrnTK
TVCGblEAHTe02808bfdnuD6ISWiyFFBARKEOM91feOo870YO9pS9TWO39suxem7I
Oa56mfBIiwGlbDpj9qWlfLeEkxYiyZRhrnvBWoLGZPmvlBqCu+t2qs2prbnTFnut
ad7SPY78543LTdQrh6nluuBLLdGdLFcX+HCtEQAmslu34WNKkc0FD5w9XP+/kcJa
pVfU2zf6ZqN4SsJz97KKbG8BvdRKo8yI1g1XsFlw81LVvpHCi70QhHxuJXInvb2Y
BiU2ZobDrO/6yOQCHca0UF2/9RjZU9PALl0Io718jQr38jI9eoBnpI/xuPHUj8so
tk3FhCH2MO9f1JvgjDSFmlMim0+ezo3rBYG5XYKT3ROLDxXSk7FL44Ov6xu09qBk
rMebPuRg6+RUOA/R1+wUiaJpi9ebunVveGKrxjmtJbWBUAZDlVOFbtZK4e6lPMy1
3GChoXsmvvcVnmPl4Y0MH7n1RrPzxDT6WizDLZKT93YrbICFCuYo4WV9L9L9CKEY
latBsCFrYyYGr7I9NXRqu89axfVXusgBEoaoi8hcDGX5tVFBx79tsnI3zv04QWOU
VqS0F1WRtQ1GCGl8LfMdHuQLzFo8SYpK30FQI66CjgEcVHfQBfZqWhOoRdaw6UVK
ESXkw8rVcU68KkJepMzV
=YW2C
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_17_47_43_+1100_3XFqHJ_=PE=pS8cF--
