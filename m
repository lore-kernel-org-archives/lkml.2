Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2CMCp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:45:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44146 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2CMCp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:45:26 -0400
Date: Tue, 13 Mar 2012 13:45:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: manual merge of the isci tree with the scsi tree
Message-Id: <20120313134512.848baf17f46729fa0fac195d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_13_45_12_+1100_CjpdzR./uO+3k_.F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_13_45_12_+1100_CjpdzR./uO+3k_.F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the isci tree produced a large number of
conflicts against the scsi.

 Merging isci/all
+CONFLICT (content): Merge conflict in include/scsi/sas_ata.h
 CONFLICT (content): Merge conflict in include/scsi/libsas.h
+CONFLICT (content): Merge conflict in include/linux/libata.h
 CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_scsi_host.c
+CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_internal.h
 CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_init.c
 CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_expander.c
+CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_event.c
 CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_discover.c
+CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_ata.c
+CONFLICT (content): Merge conflict in drivers/scsi/isci/request.h
 CONFLICT (content): Merge conflict in drivers/scsi/isci/registers.h
+CONFLICT (content): Merge conflict in drivers/scsi/isci/port.h
+CONFLICT (content): Merge conflict in drivers/scsi/isci/port.c
+CONFLICT (content): Merge conflict in drivers/scsi/isci/phy.c
 CONFLICT (content): Merge conflict in drivers/scsi/isci/init.c

Since you are feeding patches into the scsi tree (instaed of having you
tree merged into the scsi tree), you should rebase your tree in the scsi
tree after your patches have been accepted.  The above conflicts are
(almost completely) caused by having the same patches in both trees with
additional changes to those files in your tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Mar_2012_13_45_12_+1100_CjpdzR./uO+3k_.F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXrS4AAoJEECxmPOUX5FEZZMP/1j90zc8wCsFFsXXs8rCkfjd
munvgrWBLhNClhVoFVu5Az2wiruoOFpVRwgMpfqlh9cOLKsKmaOgvpeSBm4HgQik
c+xZNpHyniEiMfSVy/RF4p6v6X7lXMAvEPmn1O3ETSLg4jLZnPshyHEFHbZ+fWFI
xb8oDWC1M1R/+p/J0BJ0E4GwhxaGZHIeSsU5RbO8u0Nd/SiMqrJPxBtiaYw4zNfr
dAzVnF8DgL1pUJafON7xGY4czeLzU+fe0mZPyBFhlH69Kcjqlj1HzY3OeLiaHAI7
f03AMQEw1IEfzaovcb+ifVUdQ/S6M0t/zFzpQmBYot7SAScZFfsV2M8sWgvlfpCh
hBhWqIPBl+CN6x74BZwg0m3+OLyPKhIrQ6BIJt7EjofNkam1R4Xhp+0hiFEwJtXL
vBYD24dLkdUw7jMzdrAKeOmW8FSL2hG52AIra6/qY+CTylDSZt/N1aG9Sgw02jjX
/pOFfuRaafqHeXXyQFoTID6JxnZO/pM0cuXi0B6YUq9enN9D6YBxYXF5fPH4cPaI
6plB9zH8lE9PG4Z6h9pIgaz3BjgQyYeUoeDNn7Wj7cXZdt+P09BfJpwaFtuK3DN+
mjPxCavny6ks1f4PE5cmgkgaZhtKvAdCE8aqqtZqrYjPW5eQdrWn62qDHOiCrvtL
llvyF86FLqaLGZjS6UBm
=fxzU
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_13_45_12_+1100_CjpdzR./uO+3k_.F--
