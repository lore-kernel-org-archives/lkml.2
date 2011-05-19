Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1ESAfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:35:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46582 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab1ESAfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:35:48 -0400
Date: Thu, 19 May 2011 10:35:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: linux-next: manual merge of the s390 tree with Linus' tree
Message-Id: <20110519103539.aa1b5094.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_May_2011_10_35_39_+1000_Qp_9/XQcL7DK8vfb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_May_2011_10_35_39_+1000_Qp_9/XQcL7DK8vfb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the s390 tree got a conflict in
drivers/s390/char/tape_block.c between commit 9fd097b14918 ("block:
unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers") from Linus'
tree and commit 263fa17de50e ("[S390] Remove tape block device driver")
from the s390 tree.

The latter just removes the file updated by the former.  So I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_May_2011_10_35_39_+1000_Qp_9/XQcL7DK8vfb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1GXbAAoJEDMEi1NhKgbsTGYH/0DNRiy+ooM6v1KBsUpgPgu3
3T0I/rKP3gNTjtPSGjgYnPhAgshy8i5YTDAtxN4eVp6uGLglS5OvxZeQhgcjNySW
a9k6LvWDfe/MwvFxOwosM09cD+lWmspGOeCBHjcDp3Yz96h4FbOEk9e866csr/2p
13BeBkngXgg3MV2Hs9p/7QJa9s9o+VFTXGR748YeqL1oJqxFaaSNPGOenA3VZJXo
FRMetzq2Qrv1KhspOPrTp4T64a1VMzcJSB54Hthwuu45IgGj2zTYxwHSaCAgJdWe
MpAApMu7yfG9OJO9qBu7uySynOIoXoDChdqrgRSGA0Zlrr5Jra9YasiWR+5a3ME=
=J0En
-----END PGP SIGNATURE-----

--Signature=_Thu__19_May_2011_10_35_39_+1000_Qp_9/XQcL7DK8vfb--
