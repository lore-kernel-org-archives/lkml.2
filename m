Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2E1D0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:26:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36522 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2E1D0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:26:50 -0400
Date: Mon, 28 May 2012 13:26:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the dma-mapping tree with the  tree
Message-Id: <20120528132640.03db266f490fa5917a54bb6d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_May_2012_13_26_40_+1000_7YMJgoJoku5KgIbp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_May_2012_13_26_40_+1000_7YMJgoJoku5KgIbp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the dma-mapping tree got conflicts in
arch/arm/Kconfig and arch/x86/include/asm/dma-mapping.h between various
commits from Linus' tree and various commits from the dma-mapping tree.

Again, these commits were rebased from what was merged into Linus' tree
via other trees.   Please do not do this.

I just used the version of these files from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_May_2012_13_26_40_+1000_7YMJgoJoku5KgIbp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPwvBwAAoJEECxmPOUX5FEr6sP/24QmZOsiRXuDL9VlqWyeALJ
EtbXM5v/9Ej/s3EVZK6pV0vN6h12Srt1c+Ax6LXbjy/pUZeCFS+gBbSB6TSCpknQ
fZE4pBCgKVd/VopFGEPCi1ntCfHwAeJa9Z2NiwzJL7fwISYVa90yxQKhbj6sV/Y0
s4nB+4Jb/srK86s/4+o+HPambRHKwGjy0nfPE07X3ahcFHQOwX+rswvu3/+I/t3u
8zS08eAZDJ7B/pHf51G/gi/U62+sfrELZIOn7w6SSwKFNzWJHSTARTu2jzkiylQ8
KQpni3jwR6cNueKraWiPXZP3iQGZHAA+VUpr17UFa2bCSGwY1/AyBG7qvNkr2W5W
e8k1+djHnQxAvF1EI4s/hN6mg/lUeDEqqEgNPR9GuYAcOe2l4m2t5PfgU0cEFJqp
LRnHSIAEcB6Oy4UgjUMGclHJjhe2LY5Y/Tb2jGZQHEMQcU73j9+vMkXhaKngMk6r
OQXh7QDZx+3iqFkFjq3x9K/QamTL7XOx9b53ELvkShX0rJE1b7Yn93hOA0Qp8Qck
12JFoBF9ZyhtAgywctTJxM0SMM46Kx9Zuqr1NPqMLIlXWAdCi5tEf6r0uls6pIdg
YOVuN2gZTDXvEDYICGU1X2jfniPfrBT/Tljetw7g81WvJg+R/JfAitmXN80gi3A9
dBt4ZLffa0cB+wQazt68
=wZOd
-----END PGP SIGNATURE-----

--Signature=_Mon__28_May_2012_13_26_40_+1000_7YMJgoJoku5KgIbp--
