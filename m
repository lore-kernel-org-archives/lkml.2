Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1EQCBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:01:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57001 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1EQCBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:01:12 -0400
Date: Tue, 17 May 2011 12:01:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        =?UTF-8?B?Ik1pY2hhxYIgTWlyb3PFgmF3Ig==?= <mirq-linux@rere.qmqm.pl>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20110517120104.35ff4055.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_May_2011_12_01_04_+1000_MztEuKnDHFzbTGmn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_May_2011_12_01_04_+1000_MztEuKnDHFzbTGmn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/vmxnet3/vmxnet3_ethtool.c between commit ebde6f8acba9
("vmxnet3: Fix inconsistent LRO state after initialization") from the
net-current tree and commit a0d2730c9571 ("net: vmxnet3: convert to
hw_features") from the net tree.

I fixed it up (by removing the lines added by the net-current patch) and
can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_May_2011_12_01_04_+1000_MztEuKnDHFzbTGmn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0dbgAAoJEDMEi1NhKgbsoe4H+weo9kAe4zoDJlGHZ7oRCifA
Knd1XdB/1KuDcC11tQI6Ooa9nYc5CFAk1hxDE/RorhkED08Ufp2Tcs6cqzDvLNuT
CTZI0GZy+WDonepZzIfzEyEzeryFdu+oHEDly3wLACdWRrsIk5AW8y3RdwAXOG+F
6loqlN9WOE47jDULjT/GCHVP5mtro23Ba5y4p53D2XMp83xyjMlHFkuWlqpcjU8F
h+tWsuGPw3euxUlDXEnkvlySmgy2Wi+BPkt90yfJLxoudyOcidoCSJiU/B7tUEp7
IloRw2g0rqQSysxjt3vCDFq9JgCbUKlEzMpre+a5dTxcNFoGO0BzfbH12FULr+Y=
=C393
-----END PGP SIGNATURE-----

--Signature=_Tue__17_May_2011_12_01_04_+1000_MztEuKnDHFzbTGmn--
