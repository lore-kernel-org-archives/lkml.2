Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2CWCBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:01:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42160 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab2CWCAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:00:43 -0400
Date: Fri, 23 Mar 2012 13:00:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_13_00_31_+1100_Z+8t24Txhi5xoWgY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_13_00_31_+1100_Z+8t24Txhi5xoWgY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/ata/sata_svw.c: In function 'k2_sata_proc_open':
drivers/ata/sata_svw.c:327:2: error: implicit declaration of function 'PDE'=
 [-Werror=3Dimplicit-function-declaration]
drivers/ata/sata_svw.c:327:56: error: invalid type argument of '->' (have '=
int')
drivers/ata/sata_svw.c:328:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]

Caused by commit 343ac4b031a7 ("[SCSI] sata_svw: convert to scsi proc_ops").

I have used the scsi tree from next-20120322 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__23_Mar_2012_13_00_31_+1100_Z+8t24Txhi5xoWgY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPa9k/AAoJEECxmPOUX5FEHnUP/2EJTKhrci3W6EaNe7lttaof
3lvmJ9hGbRYNHQQDvHDM5o3gJJbw+r2UXCprQdyNTknVdtH539azs5Dm0s0rksEH
HacHUHv9/1EJBSIRpJevWApnlsDsPdQC0PaIxfciBE9DxDXOSTSscWRy8dd5pCNW
0nh9IXbTFDruL5aK1P1t9AE9dTe78sUotup24rSwetYP1qBWyWoRVyzpHt6PNXKQ
V2RCR7u1GBIcNbgMj/513rNMfhbcWK2Ab1J6Tu6O8ogAQ54VLxlFGmjX+XyI9o3b
YbAHX0/6e8td17iHa3CpIwBTaxDS9PR2QVKIoHYpgQlaIrLmK/SHvAZGHYHktoBC
wMzK/rm5ti04rhy8RrqkJ60MbzZRwUzZRmBuXmNxsJGxzErakKa6AStXZi/+iDZC
xSJ5xvn05nxRgkkhqz5UOuHzMu2c1l3CV+v/VUIu3WIiXI8YFKDebdWoxMQb62PX
OZlAdT5FXdx4DlkN2zn5Yj+hGgpcL6p1URyaR8vqg3QQs/eWe8g0n6fIEvX2kfS9
8pO4Y+Oo/H3cggrunXU3Wypm6F748no86nQ8wgLpJ7R76Jq9Syq1OC4shzFXucvQ
T+iCTUaNBpdgs82V+IcHQjR7pO03OloxLVGSENEj/Yy0if0Sv41/x+9PwIaDesGp
unIqCiqJ1nc1VJAVVbgU
=72oQ
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_13_00_31_+1100_Z+8t24Txhi5xoWgY--
