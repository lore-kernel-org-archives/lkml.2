Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab1F3Cdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 22:33:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab1F3Cdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 22:33:39 -0400
Date: Thu, 30 Jun 2011 12:33:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vlad Zolotarov <vladz@broadcom.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: manual merge of the net tree with the scsi tree
Message-Id: <20110630123325.43268067.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jun_2011_12_33_25_+1000_ydD8yP/DmDZB5sPm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jun_2011_12_33_25_+1000_ydD8yP/DmDZB5sPm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got conflicts in
drivers/scsi/bnx2fc/bnx2fc.h and drivers/scsi/bnx2fc/bnx2fc_fcoe.c
between commit 2382d2364a60 ("[SCSI] bnx2fc: Bumped version to 1.0.2")
from the scsi tree and commit 619c5cb6885b ("New 7.0 FW: bnx2x, cnic,
bnx2i, bnx2fc") from the net tree.

I used the versions from the net tree as those version numbers were newer.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jun_2011_12_33_25_+1000_ydD8yP/DmDZB5sPm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC+B1AAoJEDMEi1NhKgbs+UkIAInMaFaTppuuyQxsV45MXXnW
HpuXdIhRH9hv7mcPgY6u+D7JgbU2IrkhV0y/zdkhhnmr9UcBxv0QkdfclX1MxuTB
0lXdZ7/oLra7AsdpRcuY2Q0QH0zQSPDjqrXH9oOlmj0B+dLX2drg+Y+lk80fLqTT
0z7aRXiVgWAEGpQ057fOdIdpA7ZbkT0FItRZ6QuhF9xDFfUjm6AGCpJGfHiofWBA
MJTnlnYmZeORHf09jYFiZtreO8sOG9Cl2ctczDD4OW5YTvOSEkn4H1PvzyLYUyes
tSIlGU+uX4pMPnpn9RXXWJC4jv0nLf/diufHUR9btueyzPr1V6bbDwMm/wWRZCk=
=uIDP
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jun_2011_12_33_25_+1000_ydD8yP/DmDZB5sPm--
