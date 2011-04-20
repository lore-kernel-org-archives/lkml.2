Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750836Ab1DTEMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 00:12:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49538 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1DTEML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 00:12:11 -0400
Date: Wed, 20 Apr 2011 14:11:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: linux-next: build failure after merge of the final tree (fbdev tree
 related)
Message-Id: <20110420141158.008d61b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Apr_2011_14_11_58_+1000_zoM1jLDz_hNCkx1t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Apr_2011_14_11_58_+1000_zoM1jLDz_hNCkx1t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/video/s3fb.c: In function 's3_pci_remove':
drivers/video/s3fb.c:1388: error: 'par' undeclared (first use in this funct=
ion)

Caused by commit 86c0f043a737 ("s3fb: add DDC support").  Clearly not
tested with CONFIG_MTRR not set :-(

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Apr_2011_14_11_58_+1000_zoM1jLDz_hNCkx1t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNrl0OAAoJEDMEi1NhKgbszh0H/Az2qbqQ3FXYLsyAGqmiYcy8
4M3Y9Qj2aG8qmeOWvzn6w6K5O0eASQQK56Oze/UWOhuN8jwLZ1hjKh0qHUyFYvVE
xMWnSQ7CqQWDYAa9GzJVGhUPqvJ09FO9TMQLyBUq2m8rN8omeCFgrQhMBuJE4FJQ
7gwLmdd67QMesn7z6DH4opRR9Sn0DeBBPYftSUUGS5a5Y4MNjNFV3/ilmRGTwCyB
MMYXaRSjJzprj7hJkS+1TsJReV5ttjXYytwaZdolDw8gwngIPFdpvFUaH9F3STLs
uWhha5iFvNg+QJRFcaItwH4ZIGd0u8KgB2EC+l1VyAaJnaUrCYWH1P8B1CJInrw=
=xRKv
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Apr_2011_14_11_58_+1000_zoM1jLDz_hNCkx1t--
