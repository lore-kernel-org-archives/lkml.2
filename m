Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1DLCAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:00:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33728 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1DLCAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:00:07 -0400
Date: Tue, 12 Apr 2011 11:59:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110412115954.c3ab875a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Apr_2011_11_59_54_+1000_MT6sKQVg0ELaFbD0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Apr_2011_11_59_54_+1000_MT6sKQVg0ELaFbD0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64 allmodc=
onfig)
failed like this:

sound/soc/codecs/wm1250-ev1.c:76: error: '__mod_i2c_device_table' aliased t=
o undefined symbol 'wm1250_ev1__id'

Caused by commit 4bb3f43c6e3f ("ASoC: Add initial WM1250-EV1 Springbank
audio I/O module driver").

I have used the sound-asoc tree from next-20110411 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Apr_2011_11_59_54_+1000_MT6sKQVg0ELaFbD0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNo7IaAAoJEDMEi1NhKgbscnEH/ivGX52HsOxbgxYHq3aOERnC
hwFNEfAlYl5TAAEnWBNZoZkNIdeOtwL769sq7v/65ez26JREdYCQPsY3xEuKCdnY
N3HOaoIs0iwxeW7RFCF6OU4O7/SX7KGOstVrdkdbyrrPmTLaVVC7gNNHFl5jcrlh
v+rtBtDPxGmVBS1To3BKRV8Y6FRRuo20YNYGNZFQIkhFi6/sOCTuDjVVIWpgp6Tt
UgA+OeMFfP2jlpZaSJpl8K+MSluKM+X1OiVRLTHr6VAeYzu3nLcFiSwjQUPNlaxg
FiesfXMCDCPt0Abc/eOmZr2D4eL73cFTlHey5aduu3yBLB3bDeZ5HBd8xhjsl0U=
=E7iC
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Apr_2011_11_59_54_+1000_MT6sKQVg0ELaFbD0--
