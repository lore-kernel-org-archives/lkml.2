Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab2KADlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:41:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57669 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab2KADlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:41:16 -0400
Date: Thu, 1 Nov 2012 14:41:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: linux-next: manual merge of the tmem tree with the xen-two tree
Message-Id: <20121101144114.921fe08a8d731e3fea2291a6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Nov_2012_14_41_14_+1100_MnxBrVf=Z0g5Thu5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Nov_2012_14_41_14_+1100_MnxBrVf=Z0g5Thu5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the tmem tree got a conflict in
arch/x86/xen/setup.c between commit 6056726e851a ("xen/pvh: bootup and
setup (E820) related changes") from the xen-two tree and commit
7282a68f5aea ("PVH: Basic and preparatory changes") from the tmem tree.

I fixed it up (by using the xen-two tree version) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Nov_2012_14_41_14_+1100_MnxBrVf=Z0g5Thu5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQke9aAAoJEECxmPOUX5FEnvUP/jBkpDjbpmlYY1W9WMjRPAAO
GplJ/UzraKQUnl9zXaulbxdKuSAL/zyn9PTkfytW7q+PIC9xynjr4tfYj44l2JFk
KZYkh6IGzt3mhU/8ORynaOmNDQinXsvgJWTdsyhv6cD3F0TVZjntAWOUV80TdJ8S
uWciaLJaJWL12rpUxgaTFcsnUH74xe6B+oWZZ+cwJu4HAcUANBq8fYKrWjJuxT4c
v2LUUEnczQtqCUR+7Pzu2GUfipBU7+npWd+CviZvN5s0JlAKrLxxitjnybRNUpUA
+Hh1mlcNxxCAXY6Q/Ou5NDt+8oeABnzdTRIFsXIe0VZQsko5sgi+RIUCIfReWyYE
Tga+uPkoQ8qmUW0Eza6D916P0mRv+mKrIRqqNu27+/4CkqTp3XiQ1QHc8kEJBgg9
4jXlgDrzX9iNEk/fQKB/JlwAL3ZunJ9tyZGc3Wo9Bvsv7fUrqz1+ndvVpc2JEaXS
Zowrqb8AbirwqR8MnGZTsSOaGfpp61Wq26mmYsHdWpFLjVTFTnxy64lyw+A8loZM
Lp79MmVvX4XS06kSdVSv/98rzE7My3uuaDunWucSLtNFQD0dhHypfAlzK4AtK++4
DK9gdC88XPGcyAM9m8gA3ovBN6ab0zchqkZR0Gxl4d94tmbDNFiuW425xaWPcxLG
nkf9ZyUyzl/wJTUWqEAw
=mRP/
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Nov_2012_14_41_14_+1100_MnxBrVf=Z0g5Thu5--
