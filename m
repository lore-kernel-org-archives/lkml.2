Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1E3CZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:25:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36567 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1E3CZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:25:41 -0400
Date: Mon, 30 May 2011 12:25:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the idle-test tree with the  tree
Message-Id: <20110530122531.53399126.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_May_2011_12_25_31_+1000_BIn1NFhTrNRn4O9k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_May_2011_12_25_31_+1000_BIn1NFhTrNRn4O9k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the idle-test tree got a conflict in
arch/x86/include/asm/processor.h, arch/x86/kernel/cpu/common.c and
arch/x86/kernel/process.c between commits from Linus' tree and similar
commits from the idle-test tree.

I used the versions from Linus' tree as they seem to have been committed
more recently (this may not be the correct solution).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_May_2011_12_25_31_+1000_BIn1NFhTrNRn4O9k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN4wAbAAoJEDMEi1NhKgbs6DwH/RQ5dTxqCkA1qa4kx1/Ri5DV
esF5zPYg+iYf4zMvvTW6fBhPUeQPNEGxatB6VU8GTOVYmO2V69E2IWVhIcyDP/tx
zcTx+wA9tCh9/BofwA/b1+pWhP5S3iFoRy52C3DCp7QaNlApcZtm4CIOU59bwYTx
bt5gRI3/huP0syIFWLbHexfnFsP9Xehvar6PfUqdYVHMiWEEDFP2IiqPDvzstWZc
dk/GmdE+F0/ePmR2j+m7eJJQFKE7D/EKFkneU61h2ye/UnTCu8VPY7Bu1IZunoRK
+rvzFqYhxzktNMf5/O+fDTPH/w/SeQIOZmA7PJ+ARZV/p1beYBR4Qg/tlATfcIg=
=7g8w
-----END PGP SIGNATURE-----

--Signature=_Mon__30_May_2011_12_25_31_+1000_BIn1NFhTrNRn4O9k--
