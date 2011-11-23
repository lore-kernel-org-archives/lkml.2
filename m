Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab1KWWm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:42:57 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:52143 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752726Ab1KWWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:42:55 -0500
Date: Wed, 23 Nov 2011 14:44:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20111123144417.2da5958c@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d+ylh1iReJ.d=yqJl4HmXps"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d+ylh1iReJ.d=yqJl4HmXps
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit
839d8810747bbf39e0a5a7f223b67bffa7945f8d:

  Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel=
/git/jdelvare/staging (2011-10-30 15:54:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci for-linus

Nothing too exciting this time, mostly some minor fixes for things
normal people don't really hit.  Happy Thanksgiving.

Bjorn Helgaas (1):
      PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs

Joerg Roedel (2):
      PCI: Fix compile errors with PCI_ATS and !PCI_IOV
      PCI: Let PCI_PRI depend on PCI

Kenji Kaneshige (2):
      PCI: pciehp: wait 1000 ms before Link Training check
      PCI: pciehp: wait 100 ms after Link Training check

Rafael J. Wysocki (1):
      PCI / ACPI: Make acpiphp ignore root bridges using PCIe native hotplug

Yinghai Lu (1):
      PCI: pciehp: Retrieve link speed after link is trained

 drivers/pci/Kconfig                |    1 +
 drivers/pci/hotplug/acpiphp_glue.c |   29 ++++++++++++++++++++++++-----
 drivers/pci/hotplug/pciehp_ctrl.c  |    3 ---
 drivers/pci/hotplug/pciehp_hpc.c   |   27 ++++++++++++++++++---------
 drivers/pci/hotplug/shpchp_core.c  |    4 ++--
 drivers/pci/hotplug/shpchp_hpc.c   |    4 ++--
 include/linux/pci-ats.h            |    6 +++---
 include/linux/pci.h                |    2 +-
 8 files changed, 51 insertions(+), 25 deletions(-)


--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/d+ylh1iReJ.d=yqJl4HmXps
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOzXdBAAoJEIEoDkX4Qk9hw70P/RLjV0R+wAJhB2EIDJjA1iGr
jQhoU6dFAC6Y+u77ay2ZxnahbXMR3GJp3cp+L5xPRAJaP8CgEZGoM912p7lslPhe
alvp36J4TOp09jYXFOPKcar7pwXW4gebu0Os+tN6sSP7Z1EBYnm9Tw01P3UoMs0x
DPWlVe4QLsPKwyXjLELc5FsKDtG0MxIcWNgUd5g+f6vGZlevU4OD6FDdfDFobhBX
y9BqTs33HMQuqBtUALpp2UyRi1I0WziovxCsx9YwlwD7yFqlCCT0up5VH9je5Toj
0yzFHvAr02ibVvdUr1NabdUTjlZfTjfji/za7y0pd0sGrdfw2gbiPT7f+pyOsJ7G
JiF8uO4yZONN3VO6UXTFMyNSkE7UEGNK/88M2q8qiODtFuLtHvqj+xUOlPHxAOWW
sqav2L0bg98kr/NHNjcT3HnhTp/ISSrTqLZIVtmCc0xPz6H25NC/2qNmBYPh49vh
59egFOWh2NDkcsoN0a6V8RW9j121On+YIN+jR5xEiucAQ7qFMH5hd5RpmJyMgkVo
6H/XmOQxhTIq6E+7bv3XZECL81NxbKb96E8uCJPgYhnwbCan7dwE67cE2ZNVQEGs
Rq7VGLQ2VhZcnxAXMp487uLrGr6lWgzvEpSjFDl1CoEBF2ay4gIo3aO8LV2wPV4i
7Wz9awFsyBYdNHtJBXLd
=GPYh
-----END PGP SIGNATURE-----

--Sig_/d+ylh1iReJ.d=yqJl4HmXps--
