Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1GDDJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:09:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46992 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1GDDJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:09:06 -0400
Date: Mon, 4 Jul 2011 13:08:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20110704130858.97b7932b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jul_2011_13_08_58_+1000_3z8xA4DuCdOsab=/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jul_2011_13_08_58_+1000_3z8xA4DuCdOsab=/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "vb2_dma_contig_init_ctx" [drivers/media/video/marvell-ccic/cafe_cci=
c.ko] undefined!
ERROR: "vb2_dma_contig_cleanup_ctx" [drivers/media/video/marvell-ccic/cafe_=
ccic.ko] undefined!
ERROR: "vb2_dma_contig_memops" [drivers/media/video/marvell-ccic/cafe_ccic.=
ko] undefined!

I have used the v4l-dvb tree from next-20110701 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Jul_2011_13_08_58_+1000_3z8xA4DuCdOsab=/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOES7KAAoJEDMEi1NhKgbs49EH/RJ66FhC3LSKFnph0oslm9w6
AXk1hCXm3QCQAY6Pe+bGNBgZ84jrTrA8Cg4cbxeVRPmGECLyc7O37csp4QisRRxZ
idWxJSE4MvBKKvR/XVTyT3xOxfY8BA4OvtQtieBCLr1lvl7bupQjIxjHptGt6oQF
XyGdIa4dS+sBfTFkmxt2b5jf/9+RJLhBrpu/N/HAKn87YRWoaAMlyjLPOIpg876w
afF3vijxtmP1kzpswd80nZfNDlmOL2KPRMHq8jpMxbxp/Sb1zVj6AmWwbFHaf3pP
JpC1F54vEdemsrujKsS2/IElIubOrsjD+3TUKBhF7/pdYR+XrIcOA6cIk4vTZGU=
=wfq/
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jul_2011_13_08_58_+1000_3z8xA4DuCdOsab=/--
