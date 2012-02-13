Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2BMF1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:27:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:32925 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2BMF1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:27:47 -0500
Date: Mon, 13 Feb 2012 16:27:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: linux-next: build warning after merge of the libata tree
Message-Id: <20120213162740.9e3cb47a39da19ed89edea49@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_27_40_+1100_BUpFz8xKW0mBNlsi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_27_40_+1100_BUpFz8xKW0mBNlsi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

After merging the libata tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not =
used [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but no=
t used [-Wunused-function]
drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not =
used [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but no=
t used [-Wunused-function]
drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not =
used [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but no=
t used [-Wunused-function]
drivers/ata/libata.h:132:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:133:13: warning: 'ata_acpi_bind_dock' defined but not =
used [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unbind_dock' defined but no=
t used [-Wunused-function]

Introduced by commits 75d22cd567ca ("libata: Bind the Linux device tree
to the ACPI device tree") and c9df614ade0e ("libata: Add links between
removable devices and docks").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_Feb_2012_16_27_40_+1100_BUpFz8xKW0mBNlsi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOJ9MAAoJEECxmPOUX5FEOZsP/iJDNNYZ66k50v7kNtYX2bzw
haWtSz4JFjhSgwh5YoqSTK1CBxHbLqYbGub/cAyLgr01FqfZ4JdnrO4RDgKTUi/h
MFhQu2pygI8qjjQiGoNbmf0S73HkGJVYUy1QuJJLv/Hhn2ztzmN8sbbQurFFl9fm
99le/0j8W2ilGABplbAFFft/Hu0Dfe34CHmaQSWE+F0D3JSWDjMcPhc3FMJ0V6Z+
Lihy4Iddss2u/szXIv0Q7u1MntVWT13nnZyjkQQ48V+H4ZfpGeEaC9879CKEkjOh
jeODrN4bmWj/v12+D4k87/5QZnd6LMbGYOE725BA+ESi7wP0zXWCDzTGFauPuonP
ovaAFpRPUpZEuHxIPy5ROxyx7tjtuC39s/1tpu0Qb9Dg82q/cUUlT126xbwRkc53
v67tMsUArJrB5C4jBrtOIg0B5HDfc8VJZ+tNZxjA2C70gizg0go3HGGq3bEtoovT
FiN9oT9V1+j3gw3IDKK1BX923MEvsdMbunthKub+QGN/Wuy+mW6+LpiM2wVgUJZk
H2zPNYp8cAG395q17JDHBHbmv9OwweewlNTvefvpTvknf0JfVquLeHmv46qjyxGs
WV7YKl+7ehWEbTY0Brfc8iVgWsk0wzPJmi3l8CrCEVAP17hrT+wM4yPG0lnNdTv3
kzRTNFPVfiT2Ju3WJh3h
=gbHO
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_27_40_+1100_BUpFz8xKW0mBNlsi--
