Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab1DUWKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:10:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50074 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1DUWKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:10:11 -0400
Date: Fri, 22 Apr 2011 08:10:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Ik1pY2hhxYIgTWlyb3PFgmF3Ig==?= <mirq-linux@rere.qmqm.pl>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20110422081008.e7ebab59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Apr_2011_08_10_08_+1000_mzJoh0CfRQIyrSfD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Apr_2011_08_10_08_+1000_mzJoh0CfRQIyrSfD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc chrp32_defc=
onfig)
failed like this:

drivers/net/mv643xx_eth.c: In function 'port_start':
drivers/net/mv643xx_eth.c:2250: error: 'dev' undeclared (first use in this =
function)

Caused by commit aad59c431b77 ("net: mv643xx: convert to hw_features").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Apr_2011_08_10_08_+1000_mzJoh0CfRQIyrSfD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNsKtAAAoJEDMEi1NhKgbsFCUIAJVtutRgtnWi6n8V3d5gcFKY
DAEX7Ak+0aCEHIa24yhtbOimAK3BoklLGbyo2aZEkNfVi15qlvxeVYa3WnA4vzFh
ZmDcXVST29DP0b6AKMBQ5N6s7P2srRHSMv2izxnQjBG8u8FfjY44bgF0ih0xU66/
5wmq4sYc4y3r29XadeLhK/Lbxd5AUfdWPbaj2/KXbCRbN6T8zZb4s0JldV++u9W7
CxF7OcMFQ8coHayccgOAEen4k1Akm4JPlURDn1I3tKBVwIchtK3W6DwgbA8xCpjt
5r1PmBZoIqZpcBqortujXG/P5V+DFDiqD+HQ0Z7Kk0amfkfSGwOLYWoWJdnHTDs=
=xYoE
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Apr_2011_08_10_08_+1000_mzJoh0CfRQIyrSfD--
