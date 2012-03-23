Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2CWC06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:26:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52659 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2CWC0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:26:55 -0400
Date: Fri, 23 Mar 2012 13:26:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the isci tree
Message-Id: <20120323132646.9e258a9cf41be00e8a839065@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_13_26_46_+1100_N144SH7hC9mu6vsb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_13_26_46_+1100_N144SH7hC9mu6vsb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

After merging the isci tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/ipr.c: In function 'ipr_ata_slave_alloc':
drivers/scsi/ipr.c:4552:28: error: 'ap' undeclared (first use in this funct=
ion)

Caused by commit 837f52ee7a86 ("libsas, libata: fix start of life for a
sas ata_port").

I have used the isci tree from next-20120322 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__23_Mar_2012_13_26_46_+1100_N144SH7hC9mu6vsb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPa99mAAoJEECxmPOUX5FENd4P/A6jcvA5mOeP9uLxTmOKJLaR
tyo2Dhn0Y+DcIjszNC9hbBwUzD6VAIZZgUjz4VWaugDTfEyZ8DJMxCJ/cq31Twk8
rlf6LEDlKfO1vnRUXILrShDiQ/yuhvZeUgWd6FTPQIqimL34rW6YHUNMSjdMGD5z
vVa2cLJjx2p4pUhISSQqZO7roktnAP/PfXwD1r2gQEHczwxUxa4HcoV/XvQ7Zxlg
+5b71Q9oWklhFPEw16gZMsdABbjVqo7E8Wrr7mYsgmpamR6FtvoCingwUmoOUn8a
zw1D4URb4xXL415ybZ5eq+AF9+avDvEHUUEnhp9dZFlfTMQJL//C3DO8d06Kozkk
huYRUp/1T/Wh0iSoNnRtZXge8yKSJUpwMYuaqU3iT4sVRrBMTJ3TvJPtW6ZxFjAN
sgx05Xs2xxLNnl4erJxsmxSaiVZwojbtQBdRv57HpCEUzs/4T/6uPbWTs68FOtYg
OOUPz2V2LfPOWhVZc/KXgZs5hXGCxUJiuFNVSp1zQPCmCmcEzTSXZjO87DcIxTkq
2qKh8LWE1UgNMULozI/U21tIogH3iacIj3k2kyYoFlCKBoZ40Mkpu6Cna+TeTI1V
RPslAsiTkpVfpTAck1mZEhiyW+Fq9jGsGuLItXltWWqzvSWld/sdtVBs+GYUe5pR
T/vEmwRVJsA+3qFrMFnz
=YtrY
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_13_26_46_+1100_N144SH7hC9mu6vsb--
