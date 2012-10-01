Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab2JAEY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 00:24:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2JAEX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 00:23:27 -0400
Date: Mon, 1 Oct 2012 14:22:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: linux-next: build failure after merge of the btrfs tree
Message-Id: <20121001142237.e1fdc75e6d338f517d5c35d9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__1_Oct_2012_14_22_37_+1000_xCec8MyIMJzRxw6v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Oct_2012_14_22_37_+1000_xCec8MyIMJzRxw6v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the btrfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/btrfs/disk-io.c:34:28: fatal error: asm/cpufeature.h: No such file or di=
rectory

Caused by commit 2fcfff234500 ("Btrfs: do not async metadata csumming in
certain situations").  Only x86 has asm/cupfeature.h

I have dropped the btrfs tree for today.  This is exactly why your tree
should have been in linux-next some time ago ... :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__1_Oct_2012_14_22_37_+1000_xCec8MyIMJzRxw6v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaRqNAAoJEECxmPOUX5FEJ1oQAJkpukoQju6GAsIsYI40R2Dy
ur1aNFTyHv15YqxsJXFRH4kRDWLR5vF1Ym14Xe68mTs+Yp8fsbffGiUwbkkyzZNi
wNAPmBBOqakpIzB3nG9sJ4ExKlQ6I1oF06wFubBWih72gNXX0DU1ieMevFM6f+wB
fwWgCWSrGTB5rG16p2t8O7F8XrE+Jv4drtLnriPMHyOG6Yj3fFoJq+hYpw7uMFAa
UOoGZHdxBQ6JxywkOwFVKX2A55mRige+ixgIpilhJxbbyGingJrsgkB1BPvcHwM0
BhkjHdrTs6RThiiVY8f45CVDUkoDWLCtGGCCy64NVQhrAmIFmuLyxa/cPn4N1VlG
qb3cPcpvfxwzMUU2sV+Ftpopj6wLdq3EG5YmCSnrb1TqrIc5PlD0q7RL7EXWHNLt
xmqepA8A512E4zwltPHiDozeMBxYF37aZh/nEmot2gEATA4ORgDoyETL5CHox9Ex
xGhWTBKDA38WuYqZS6P4udNyKP6vgvuM+qz+RxO7ZLhckllzG1X6XnSKpa8W2pp1
2T1K9m4ENvQ0xUIcxz1vleToVtnplRDbcM25ls9KWnjHvy+0JhMBDI+bY5Ekq4BR
Bsl5KjKhLRp8P+Lthe7Auq7HvsUFJ8zZnox0XNQO6Iyy2ovb2aw0X1FO/gYN4c9w
w9ZVVM3VZLz8gIaTmEF2
=kMk0
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Oct_2012_14_22_37_+1000_xCec8MyIMJzRxw6v--
