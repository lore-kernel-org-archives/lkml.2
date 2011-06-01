Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab1FABBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:01:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45667 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986Ab1FABBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:01:47 -0400
Date: Wed, 1 Jun 2011 11:01:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110601110132.5485aba4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jun_2011_11_01_32_+1000_Wlq_KLq=E81YqJ4Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jun_2011_11_01_32_+1000_Wlq_KLq=E81YqJ4Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/block/xen-blkback/blkback.c: In function 'xen_blkif_init':
drivers/block/xen-blkback/blkback.c:812:6: error: 'blkback' undeclared (fir=
st use in this function)

Caused by commit 2a46117c6050 ("xen/blkback: potential null dereference
in error handling").

I have used the block tree from next-20110530 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jun_2011_11_01_32_+1000_Wlq_KLq=E81YqJ4Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5Y9sAAoJEDMEi1NhKgbsvS0H/A+RDOkr/aGoMzZEXh2OcHOQ
/AToiktAw1Gonva9zHQ1H2+vrASKfa6pC7zGmCbAbTIjLvUXhOEMO9gNS2Hqwjn/
ehLcBWDTvUn07it7BnQ8SsGlSCi3rMse1MLsQDczqE5lbTjqzJ6YqvLE/5gOThBV
dhpK/CLbzPg70PizAjz/iWz5/bmTqoHbSXyYU1iWqp+6lc/Lu/0OoGKQSSzFIhxs
+LWvwFthdUst+/rByvMWAn29r9ZrC9c7ITPMyVWhbBB6WZ4XJMH/iQPCxxclVGfv
ir2NxXA6Lct+mSwEnP8SXH8azGzRHtrpTm4/zYcw2VcxtK/Qn2jtGTvTAJ1QbFM=
=6GCT
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jun_2011_11_01_32_+1000_Wlq_KLq=E81YqJ4Q--
