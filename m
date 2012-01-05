Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2AEAHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:07:23 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42465 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2AEAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:07:20 -0500
Date: Thu, 5 Jan 2012 11:07:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: linux-next: build failure after merge of the pci-current tree
Message-Id: <20120105110712.2666364926458942240d6534@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_11_07_12_+1100_5ENDfZ4o7VNFxLR_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_11_07_12_+1100_5ENDfZ4o7VNFxLR_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/pci/acpi.c:81:46: error: expected '}' before ';' token

Caused by commit 4c33d0af35ba ("PCI: Add Dell Studio 1557 to pci=3Dnocrs
blacklist").  Please build test your tree ...

I have used the pci-current tree from next-20120104 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jan_2012_11_07_12_+1100_5ENDfZ4o7VNFxLR_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBOmwAAoJEECxmPOUX5FEiw4P/iSC80heWsuGny6/cNxoForo
86lp+e9+8kqd2jPl1MLK7StnqdU/QJ+MehhUlF2088Mf31T4ixwd2XVvZ0J09BiW
wDA0SAGCtWxSxL+xMb4rK2Bp5XWODDyG30367X6P5Xu8ywsbvpTSa6cL8sk+2z+m
6HZmd2/pt8UFlSx1Tl4kfQLQePNLaOUAD+c/QF9ysCqfyZpPd9NFbFC86g795ouM
BTGXO55lgxdlqpL5LL7/RSp8LEeuxVBJ4GI6NGTl6bCUoPYzcyMXAHLln+LtHnpl
sxF2JzaBsjWRqx1UErAFGjkPNMrfaZyyU5QdMbyOmRG++nwVe8dvWvO0eRSEZamW
AuzkCWHFbEayTTcuZJMnSnvE7pMWvfss57h7lvZTbCptSaxGazqR5YFUH5QfXztW
um8U3eqt2FQS7L5TLktMwOY96QD/OfImF2xtQl5gyzUy0CK72aI6OsjyeoY0X/j6
sBQ3Zg0DJzK+AjV7aZXUaLAbZrBITltQgP6GAZ98+6sbYi9O/P/fnLqtNCWcNDZX
Gd99DgfJzNP/BUQX9ZdzB9Fq9qkRvpnZjffWzaKB1/aOtBAWq8rqRklFDjrdgmhU
Qd4+tTv0KGOBlYni0bjRyX5+SnGPrH6Lk3+1AU+0xsU9FhyTzCBXhOdsJ8pJXg6Z
q2RWdX/iYl+wPqzZobRK
=vDVK
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_11_07_12_+1100_5ENDfZ4o7VNFxLR_--
