Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1ADC3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 21:29:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42622 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab1ADC2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 21:28:52 -0500
Date: Tue, 4 Jan 2011 13:28:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Mason <jon.mason@exar.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        stephen hemminger <shemminger@vyatta.com>
Subject: linux-next: manual merge of the net tree with the pci tree
Message-Id: <20110104132847.de49be89.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Jan_2011_13_28_47_+1100_UUs6wAdx1GWG05ah"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jan_2011_13_28_47_+1100_UUs6wAdx1GWG05ah
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/skge.c between commit
1d3c16a818e992c199844954d95c17fd7ce6cbba ("PCI: make pci_restore_state
return void") from the pci tree and commit
7dbf6acdbad2fbc6eea72b58404461dcb7c6d9d2 ("skge: Do not use legacy PCI
power management") from the net tree.

The latter removes the code modified by the former, so I used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Jan_2011_13_28_47_+1100_UUs6wAdx1GWG05ah
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNIoXfAAoJEDMEi1NhKgbsIdoH/jG8Bf8qBF3eRqkmn2eThoHq
w5G3XAXiDXNtwa8LSNvt68tZutIivWGT0COhqe47zGajlgKjshAji2dfdVdsAWC2
SSpFLQkn7r9cXZMcTDoSM2hZzC/+IJMhMmBolsH6dZVBCPe5KMCJkHgjCeVvb8sI
LrxG6w9j4DPvmiV+kGv4/Z5hEpBI+p8uPHuGWtnnsN+J/lN133zHVBYYwGVtRm4j
6sAccIvBCEdPxnugGyTfgiE+2foQ8uFtgKqFET2SOee4r3alotxWysuesDLYhghe
DuZoSPXhhVSeJmkv0giP73uy5vI8tqvU2W+30VSdhKEDyKYCgTwh3HI3xRizqTU=
=8aXW
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jan_2011_13_28_47_+1100_UUs6wAdx1GWG05ah--
