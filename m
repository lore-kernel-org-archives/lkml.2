Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2GBDTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:19:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41043 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab2GBDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:19:17 -0400
Date: Mon, 2 Jul 2012 13:19:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Holger Macht <holger@homac.de>
Subject: linux-next: build warnings after merge of the libata tree
Message-Id: <20120702131914.510857dc84182e95641e7e97@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_13_19_14_+1000_dIW6g_bzX.6yFjZM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_13_19_14_+1000_dIW6g_bzX.6yFjZM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

After merging the libata tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used =
[-Wunused-function]
drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not use=
d [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used =
[-Wunused-function]
drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not use=
d [-Wunused-function]
drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used =
[-Wunused-function]
drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not use=
d [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used =
[-Wunused-function]
drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not use=
d [-Wunused-function]
drivers/ata/libata.h:134:13: warning: 'ata_acpi_unregister' defined but not=
 used [-Wunused-function]
drivers/ata/libata.h:135:13: warning: 'ata_acpi_bind' defined but not used =
[-Wunused-function]
drivers/ata/libata.h:136:13: warning: 'ata_acpi_unbind' defined but not use=
d [-Wunused-function]

Introduced by commits 6b66d95895c1 ("libata: bind the Linux device tree
to the ACPI device tree") and 3bd46600a7a7 ("libata-acpi: add ata port
runtime D3Cold support").  Several "inline"s missing ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Jul_2012_13_19_14_+1000_dIW6g_bzX.6yFjZM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8RMyAAoJEECxmPOUX5FEBzwQAITpH3JKfJK41VMY6t2l94Uf
fxijR6/CqoBYSpBUFcpqmSgv2JjpLY1CT8NKh0GgWmyrrP92gFqlhQfss7Gp4n3I
nVPI2I3I077LfvelkdUtYtArKTCmu/0NPyo3IedCG1fkCdQoSA3VtqQBArI0jFG0
exnTs1VSY8CP7b6jHA5zsHEqoVPBK8wHje6CqHw0aOCKSBqqUklsxfubC4dj4pwl
L1g+29GI1hwnkg8IVDGyeba8hZ3EVBq8jCoZIZXNfrRElAU2tQt3fkG9hmLQ1ik9
maB1YI6Oo5oJhOQExKwol2EOkN+bLB/D69MEQ94Ettn/MeprNe5d0F+MxvD2Xpdj
vIMBqoMDPx9Rxq7VPK0GHMybnNoqoYrYZ6Wsdt5KyQqRew6+EtPZbBdHNH5Cv3dL
WPUxYC4nKLxTfbtbSHFbBXvCMsTfjhjT9kyLJx1ln7N1JiYnsBuaLQOSZY9gGmrv
bQzxqW1yzw3Hd2G0E8otDs3+/BPaUW1Xt8zAKk0s0e5CSe2dSnJlIlj3tJvm7Bbu
11yX94nL4PBB45QAbguWrSzIb1mKliwfAALLeddNooJ1yG/jHjhtYzzwq2MPqSbE
9PYPRr8r2hjQX9QUoFyhG+mOY8tDoFG/bu9ziouI6/eKyxpKYglcplaadQwxFw9q
C6eIu+JNfjcbGKzahh9A
=usCi
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_13_19_14_+1000_dIW6g_bzX.6yFjZM--
