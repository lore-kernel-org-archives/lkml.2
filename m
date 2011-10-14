Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab1JNDbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 23:31:55 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41635 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1JNDby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 23:31:54 -0400
Date: Fri, 14 Oct 2011 14:31:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the trivial tree with the mips tree
Message-Id: <20111014143142.392df4f9634efc30febfcfaa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_14_31_42_+1100_H_SLRCv4x_ElQCeB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_14_31_42_+1100_H_SLRCv4x_ElQCeB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/ide/Kconfig between commit a60891de4357 ("MIPS: Alchemy: remove
all CONFIG_SOC_AU1??? defines") from the mips tree and commit
6af677ea59fb ("Kconfig: remove redundant CONFIG_ prefix on two symbols")
from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ide/Kconfig
index ff7c6bb,76b6d98..0000000
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@@ -681,8 -681,8 +681,8 @@@ config BLK_DEV_IDE_AU1XX
         select IDE_XFER_MODE
  choice
         prompt "IDE Mode for AMD Alchemy Au1200"
-        default CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
+        default BLK_DEV_IDE_AU1XXX_PIO_DBDMA
 -       depends on SOC_AU1200 && BLK_DEV_IDE_AU1XXX
 +       depends on BLK_DEV_IDE_AU1XXX
 =20
  config BLK_DEV_IDE_AU1XXX_PIO_DBDMA
         bool "PIO+DbDMA IDE for AMD Alchemy Au1200"

--Signature=_Fri__14_Oct_2011_14_31_42_+1100_H_SLRCv4x_ElQCeB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl60eAAoJEECxmPOUX5FE/cwP/j9lrLMz24+5Ag+xtogEfmaf
+yR9eklmlzinbJ1Ss8+ns9XjzLpSt55kmHcxKlvPL7w96j2fPV8dyRS74XEUTUjS
PUemtOl3fA07c4TGQyB8kJL1rzwy/CMXI5HqlefqolUy24LPb9siqtN8pcR1bQoM
k7nq9m0ukbjApjOALGX3VhE0kbOA70FwoZnTyXY52gl/kRLLlvvVBsFc0rLTL7ar
gg/rZdOD5q4BBd8qLUieGcYMO7htaZtgEanTOymjqT5gE6TdIwwolwKarI9xbCYa
awfg8K6+3JY1+5A08L7+LxiSzVViWrn1EqTkjmShgIzTocxqsB0kP+kbfZqdoEbM
aDtkgc5/2+e8k0qMICJgLjOzQ+1IHRDqfE+QbzgdICaEIejaWRtN/gp5WRSU9zPp
jtAoqMoMvIIhZYAlF+6miNH0Usok03No/dCEVsdvhbiVVdltX/x0M5eRd5rB5QmN
SagaEVfDX+TJsTVbdfRh5pM+Fj8U8kgv1Onwxh59Jm7kUmBtUgnbLXLEFa98kOQR
ga+FJYzUH1ju8Lq/9/GHM1lG6zpOSm0Mv3VrQ3Q4Fz8rov/loQ6GyzArlAwHmjhg
vOwpbceSOlT3LA5/KrebAuw6NOWhX8INRHaJeVZgHySGBNi666vxvQJ48tiLiHfd
3eLVPg7wNZ3IfoecWO1A
=OVCB
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_14_31_42_+1100_H_SLRCv4x_ElQCeB--
