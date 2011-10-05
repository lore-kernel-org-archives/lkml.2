Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab1JEFYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 01:24:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35404 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916Ab1JEFYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 01:24:22 -0400
Date: Wed, 5 Oct 2011 16:24:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: linux-next: build failure after merge of the devicetree tree
Message-Id: <20111005162414.da7b35fd2baf34efa63d2f2a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_16_24_14_+1100_YKO.9yE=gMuUI4j5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_16_24_14_+1100_YKO.9yE=gMuUI4j5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the devicetree tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/tty/serial/altera_jtaguart.c:483:3: error: implicit declaration of =
function 'of_match_ptr' [-Werror=3Dimplicit-function-declaration]
drivers/tty/serial/altera_jtaguart.c:483:34: error: 'altera_jtaguart_match'=
 undeclared here (not in a function)

Caused by commit 85888069cf5d ("tty: use of_match_ptr() for
of_match_table entry").

I have used the version of the devicetree tree from next-20111004 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_16_24_14_+1100_YKO.9yE=gMuUI4j5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOi+n+AAoJEECxmPOUX5FEjLQQAJpWGMTaXI4mWecKFrwXUBiL
6Dd4ACAcCakjQG3kCMKBtcPHSYU2MEmehGMkwgfotiOxPKDafUmBnvnj3Bme3s5i
CGhvmidkJdObdS1jLFNoxLznLGOJwkh4g4l55fSCvCctXo4OzknJTQcBeH4mjDon
U1iD6EE7yHDFaKnYY05bCyRucExemGiaxJOlruqmmO2uHGCd+WbKad+jWdguemi4
u2SyQBVnivzF1x/nL6bOGGZhfy+jygRKaCNPY7i5GgdIW/oniIxaQSbyX9sOgcmr
hZES5dk4153BsrVrN+8shEi8zEMtxJ+7OGQKijdskCRa+xNNvITUCiM7KKnQp6fZ
xCN+TsSM1jg5dhmStzTHcx58UMXx0IpzgBlvi4IFH/sc/7pPEN1xQdxrUGH+2p10
reIGDL6inEpawFPpHGt33DNa1ITTzQhKL1qbtptbOI25B2TWcm9BirBvom2KUG2M
XTMrTqI8FpY9cuhlkTlaCCGD4gUgXBs15LCizeR+veN7DZXPYuIj7k8CqraXj7mb
SNsTlmaiqQV96y8xdZL6HlpbeMdZFD0GrlbBj1qRHSEraNjZl+W/WKxPD7Hu0mj3
paG7VVYxczHr1bXTjQemJ7d1d1rWWZjaZO5T7vJuBOrVjpr6AY891fqjs/toyToq
8UvTrG6WvUnID320ow1P
=FUp0
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_16_24_14_+1100_YKO.9yE=gMuUI4j5--
