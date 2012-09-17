Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2IQDRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:17:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53255 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2IQDRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:17:51 -0400
Date: Mon, 17 Sep 2012 13:17:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Atul Deshmukh <atul.deshmukh@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Subject: linux-next: manual merge of the scsi tree with the pci tree
Message-Id: <20120917131744.2f646ebfca9806ee5850fe03@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_13_17_44_+1000_VVyLVhEysXjtrb_."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_13_17_44_+1000_VVyLVhEysXjtrb_.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
drivers/scsi/qla2xxx/qla_nx.c between commit 100924388407 ("[SCSI]
qla4xxx: Use PCI Express Capability accessors") from the pci tree and
commit 8fbb85e5f4c0 ("[SCSI] qla2xxx: Wrong PCIe(2.5Gb/s x8) speed in the
kerenel message for ISP82xx") from the scsi tree.

The latter removes one of the functions updated by the former.  So I
removed it and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_13_17_44_+1000_VVyLVhEysXjtrb_.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVpZYAAoJEECxmPOUX5FEf1kQAKFXJYMDuDEsVUNhd7roUjTE
Wr141pwxzCGhGNbhOcgar/Wq/xxKlRdHgHQhlnQX9vUn/Nspwo9ms+jr427MNu23
KVC/J+66dhv5eZrBUEbY7fFXZ+pNJlT4B55lfKEFgtFII8OEe/7WhbCzXw/s4yWB
OaJC2JPT5HdpEywRkoKHF5wiaLcxymJMkHC7/su6Pz7d2Bt/UIsuiHewiCWZePfL
mfqHE4xSHRu3gCyRFMrzF1OK65+jaIspQOgxVL0p3rmoW2qwefe9R4IPE843Rlnn
4QeZPbdJoHfFT7+GGhCapjhmkduJl0eaXXJvio4g/bH9vPDQqCoWIfaFrAedeXRY
DSdjRybdgxNgazBq+EXEKB78dqrFCxTjb67DPOPCGKmGPxtlWjX91sKZgqRFMn1A
FPHY1zwMe0XAVLInououQpsHx0ql/HQJwWh7Afp1SVVXRJm2Rv7gE2fO2K62nF9w
tgJQfIa902B+Lc9trfsxyWV7tw2nLw8mL4U5A0XtZoW0CQjcXxRn+3Uy2VYppdRU
rvIHHJnofxRDjxB9+F+ZA/0yJGQGh0KhWtssg9/xX7jbrbjzLCtNvLs9gu5vxGm1
v5u+eyoXnBAVhB+94/6p0K5tmWumVxzB7pQC5SXA+MMxm+N0bSQS7zV5r66Ry6Ly
omanr0NNSJoXI/MA0oas
=xpXv
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_13_17_44_+1000_VVyLVhEysXjtrb_.--
