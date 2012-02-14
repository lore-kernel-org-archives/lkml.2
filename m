Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2BNEhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:37:08 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59001 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2BNEhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:37:03 -0500
Date: Tue, 14 Feb 2012 15:36:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the irqdomain tree with Linus' tree
Message-Id: <20120214153652.7850e2bd7b87e92008c15c4c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_Feb_2012_15_36_52_+1100_eGHCoyqCdxn7xMwh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Feb_2012_15_36_52_+1100_eGHCoyqCdxn7xMwh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
drivers/mfd/twl-core.c between commit 6252547b8a7a ("ARM: omap: fix
broken twl-core dependencies and ifdefs") from Linus' tree and commit
7da5a66bbf1f ("irq_domain: Remove 'new' irq_domain in favour of the ppc
one") from the irqdomain tree.

The latter removes the code modified by the former, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__14_Feb_2012_15_36_52_+1100_eGHCoyqCdxn7xMwh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOeTkAAoJEECxmPOUX5FEA3oP/3RCxOvH4A2g5KL+47gxoP66
Z8KQWcyLeoIj9Z8EoQTjG0Ylcnl4laVaajqo86egJWEyUsOczm2lqBzgF5j7yp3/
fjbuEwWpu0/nLp+mktRYqr56pXuzTGjKl/xiK2qqOw2jNSpaEmo8+qOg+Hbgq5Ye
ul85vo8Uj0KW19zwxFpAHG+qBBS8SYLrY6b145IVry+z3t9/tFF3njBUAMeySnX6
VKlS9C+qr9d0/Wnk9Qp4q5PnoE0M0oRXYkVw1b3BLmb00j4H3TWDg1OgtGtBObT5
jDs9UtixB5DavtcqONw/FCKRCAo1Jof3Ak8jXXlXppj7aeXti0pHcZ4Jhh40Z+eP
9ncF9gDsBpG7qujVeh/TH3Tgfy8DYoj/lHrB1wSjuSWLpyovVRUyM+dXuhXVKIoT
YCVBcBZMc3WiQA6u+RX/4bL7VdSIjb8stfHQ1zLiRFDfFHnjFbUMgUzG9W5wo52s
GjrJrPiGloXpIDb1q32EH206ZK0b27zylIke5uBWZO94niLUWXrF49jhAPzFIrH4
p/SRTperoAWGzRYeKsoB011Vc+BLVLwY63hfu6Qtcklp8wYDVzL/JzVtAiXtcwZo
mo8298vZpyBXvhrNnInnJUpqyc2rZIS/8M9pw4hp5npNX5hL5d43GhNudyY+1Zrm
1wLCUTcJJqrqz/w3p8pE
=rZjT
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Feb_2012_15_36_52_+1100_eGHCoyqCdxn7xMwh--
