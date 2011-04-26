Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1DZCI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 22:08:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58417 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826Ab1DZCI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 22:08:27 -0400
Date: Tue, 26 Apr 2011 12:08:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: manual merge of the i2c tree with the pci tree
Message-Id: <20110426120822.944b9ac6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Apr_2011_12_08_22_+1000_cRtLfdJzZh+2epW+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Apr_2011_12_08_22_+1000_cRtLfdJzZh+2epW+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Today's linux-next merge of the i2c tree got a conflict in
include/linux/pci_ids.h between commit 1b1937455d18 ("x86/PCI: irq and
pci_ids patch for Intel Panther Point DeviceIDs") from the pci tree and
commit 6f19955a79b6 ("i2c-i801: Move device ID definitions to driver")
from the i2c tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/pci_ids.h
index 52f4ed4,8abe8d7..0000000
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@@ -2477,13 -2477,8 +2477,11 @@@
  #define PCI_DEVICE_ID_INTEL_82840_HB	0x1a21
  #define PCI_DEVICE_ID_INTEL_82845_HB	0x1a30
  #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
- #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
 +#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
 +#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
 +#define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f
- #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
  #define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN	0x2310

--Signature=_Tue__26_Apr_2011_12_08_22_+1000_cRtLfdJzZh+2epW+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNtikWAAoJEDMEi1NhKgbsNygH/3rjuLJVKbG5SHJdy09ng1TA
uc7hpSPfz6NI20Bboxwty2Ulhn5i7i2bqURH37swV7DUhS8T3ypCyQpHwYwXYPBy
sC6YwNBgcFiIgA29Hap+Asf+NKQBisyWmUVf+vNl+d9VJBzl2E83jYTJFsfIunAm
csZpg7ashsLAv1lecBCgcNfEzT561YkekDh0PzmHujOD/lNabGLpFkutrsISkMKN
O2brwLt0V8sVjoucfY+Z8cLD9QsjNQk2DTQZ/uOjsWzsgJ7LX4Bsqx4kWFQxYEjp
rEqxZwP+5Bry7r68FY11KMT7gQs9sJUs04nrOARW1totvFW9hKNO88l49bYFD5o=
=8NIX
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Apr_2011_12_08_22_+1000_cRtLfdJzZh+2epW+--
