Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab1KAXOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:14:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1KAXOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:14:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6517"; a="133226960"
Date: Tue, 1 Nov 2011 16:14:30 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm fix: fixup machine_desc missed in merge
Message-ID: <20111101231429.GA3446@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit b4beb4bf9934d151bf4581a54ae028927374cb2a:

  Merge branch 'for-linus/i2c-3.2' of git://git.fluff.org/bjdooks/linux (20=
11-11-01 15:07:19 -0700)

are available in the git repository at:

  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix

Stephen Boyd (1):
      msm: boards: Fix fallout from removal of machine_desc in fixup

 arch/arm/mach-msm/board-msm7x30.c |    4 ++--
 arch/arm/mach-msm/board-msm8960.c |    4 ++--
 arch/arm/mach-msm/board-msm8x60.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--=20
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsH1VAAoJEOa6n1xeVN+C+M8QAKTtXkywdF91TdzpPtbDrXU/
4mfa5o1thMVbj4X3nQS7E+6hwkYwN5EsITNFoKRDXT8M0TqJkFKPqVmlRBFn5Nip
kL+ROFCulxngrpDTVdzOkHWLfjTQsxUqqGPq0aigqyEyP/MsnIUXr9lAW9zg5qqp
8LcR+l2wtEZUqgrEaK0lM2f4vwQfxn2OH8dXKLAZdQRMbvW+I1298Yqgwk+aUstf
dz8EcZHMYwMy4Y7VePkIf4CILeW+B/Jyl+IeRpa8wLvx07I/Mdt9mbOX1yWtuC4x
bZqOWW3N3vZObMvIW2B97GT+RwcOlRp/y2951fYj8PhtsiRcsmDBYEOI4q0918q7
Tvt2hS62P05Pck1rkYUpNsqD7+VsLb0m2iQlvRQVDoRv4ip0x8IZY2ofD8HZFt/w
btiOEybJOrlot59l+cfdfA2/pNKZWIwZrxSSD6AbsE3jv5KhWd2KoxIhhzl17d9v
QzEChG3rH4qkZsohFrpDHLCoOlDF3+WKzxfRGnER45Ef62CZntn4qepu8FwQAqtS
CzT1gfF3LjeBq5UTVe8MXIAHS5xwBlptbNG6ZNJ08Ql3JsCbySajDgdFtMcKQxKc
3N/RvfWXURJbnr0nAoVBsUUKiQ2bBC3CFL4jBqKzB7L2yolBMFKBK43y7vwszf8t
0OwdIfLYabGQrpZ9878r
=EiNi
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
