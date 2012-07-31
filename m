Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2GaCs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:48:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41342 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2GaCs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:48:56 -0400
Date: Tue, 31 Jul 2012 12:48:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the bjdooks-i2c tree with Linus' tree
Message-Id: <20120731124845.81837e64e22f78795a9e7dab@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_12_48_45_+1000_u/++0bT.czUIqkkf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jul_2012_12_48_45_+1000_u/++0bT.czUIqkkf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Today's linux-next merge of the bjdooks-i2c tree got a conflict in
drivers/i2c/busses/i2c-omap.c between various commits from Linus' tree
and commit d06333b7a618 ("i2c: OMAP: Add DT support for i2c controller")
from the bjdooks-i2c tree.

This was a complex conflict and since the bjdooks-i2c tree has not been
updated since May 3 and I have been unable to access it for some time, I
just dropped it for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jul_2012_12_48_45_+1000_u/++0bT.czUIqkkf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQF0eNAAoJEECxmPOUX5FEggoP/RQrxj2Pl8dBBjVBKkHJEMos
OVRyk2lcO5BR7iHPJS+ArB/K6QfkosPAa+QgrBn+JIL04hbnGCAQzkqtNXidLgVG
TMrupy/8msMv4jYAJG6wkGiOaFNeAJgkLlCaGARe3dA0QAYNGJkFfNOQoNP1uVtH
vHAkp1ROAOl7sh6MJ+IQ2ibi0Q6UCsltxRHtbOU/WGJTLPQbYOuO2oAWKPl4sIUz
vD8vKKF8SrXFcMZzeNx9/ty8AgJCMBEdxOqu7Z+iv9rrUSqKwsVJTOWpmdBm73OA
llsUhrbQ+fx/jml9j84oMwT/k0kaPY7DQfgiTZ9Tc7rbR8IsJDfy30gl203SnyhQ
OEZYJqj8CFyWzcdL3lZtQMrp51FQHM8DuPl41BKgqcmhZ7XTa9/jNzJgatuJ9DDG
NWehV6C+dk0tY4K0w06o5zfaPVXLyDrRVhfBiKSfY0nbqGh9SEH4KJK5ZsBkrsVF
oRNTt/Jz9ePwwLD+kGOw3Cf8NI7zqXe/uz1bpyV3Sf+ni03h+2mgJ+D2UdbldWXX
fD7eumDhsumdcTBioXcVSYhvESbPYBNq3W9yEc0UKYtE9nTuo7Dvp6g/BidEUyd8
zPDv93isC6Mwg1ixkj3bg8cpdJWwEcqZaW7TIPUFKCpQpMhplzZGiUMl9V4MP88N
JxXsz8l4eeiMe2PBFLaA
=yzRo
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_12_48_45_+1000_u/++0bT.czUIqkkf--
