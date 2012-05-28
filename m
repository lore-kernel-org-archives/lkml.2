Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2E1Dfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:35:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57271 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2E1Dfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:35:43 -0400
Date: Mon, 28 May 2012 13:35:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the dma-buf tree with Linus' tree
Message-Id: <20120528133540.19498993351d66f959f079b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_May_2012_13_35_40_+1000_+bH/O+QNqK6_F07M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_May_2012_13_35_40_+1000_+bH/O+QNqK6_F07M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sumit,

Today's linux-next merge of the dma-buf tree got conflicts in
drivers/base/dma-buf.c and include/linux/dma-buf.h between various
commits from Linus' tree and various commits from the dma-buf tree.

Again, another tree that was rebased before or after being sent
upstream.  Please don't do this.

I have used the versions of these files from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_May_2012_13_35_40_+1000_+bH/O+QNqK6_F07M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPwvKMAAoJEECxmPOUX5FEtloP/2hJ/DTOtqpPNkpUGTVD33yS
oQaTf1wdMG6sgUgI7MUtnZyOSAdq8L1dY/zMqjGNUmXTLPri6LsDAVySTx7JAO2A
3LW+Ic5Vy8mQgUofPjSFO/fYYCVUhO38Nq5e0WSvfW6LOJOFtj7Za5QCc3FwSeOD
NVpojK4/uXfz4O0VRSi24Eh7LOnA8xpM7UunNHWBZDXlxpv7nMW/JAlmLzokcUX8
end78AiXpCxB4uKjIg33W0YaZmDtyQk2Qx9ZwSrijrvGpVLgg/ciM3xY4d8I/c/6
5x9jzy/EwrX06WhOGH2HT65q66B0KCCQG4kNayI1JnM7MRuESqUuzoTvv8oH94Yb
ZrNI7bQzzXaPhAudZFgqumxfBCp66drBPLqE+vfruMgC9kQLBm1Yl5nTyWpWE913
k2rCdguAtgkYFsPsOAPxc8nj+KbAxJ5bzR2RU4PkT0N4Mm7kpk7wwwCUM7w+LXfX
6F4ZBAxH9Po0L9F+fWcG3HHgaydaXbT30rucK2ypr0RSfap8bXBdd+XLaMPVlGCW
hUOIDUKAZkSYhx8HQCJMwlIxjiqiU3WtvtXrMn2mCq3fwjp2d9Vy0QycfrLxxT/4
++FA89+XvhOyI+Y5uMcXEUtF0u1dRg2wbKw/apW8Kqz1A8xfzSfaaZ58tB0/qcnG
SyzVwUIMAOvjwpH42W3U
=n0J0
-----END PGP SIGNATURE-----

--Signature=_Mon__28_May_2012_13_35_40_+1000_+bH/O+QNqK6_F07M--
