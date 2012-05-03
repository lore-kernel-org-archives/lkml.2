Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2ECFfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:35:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47095 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2ECFfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:35:23 -0400
Date: Thu, 3 May 2012 15:35:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120503153510.ce4453a236d89250fb8dacde@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_May_2012_15_35_10_+1000_3anisiSgjMcOf=EQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_May_2012_15_35_10_+1000_3anisiSgjMcOf=EQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/mach-ixp2000 and arch/arm/mach-ixp23xx between commits from the
arm tree and commits from the arm-soc tree.

On Russell's advise, I just removed those two directories completely.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_May_2012_15_35_10_+1000_3anisiSgjMcOf=EQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPohkOAAoJEECxmPOUX5FEGm8P/0GkLwnByoCKyL3+iYzAtt1d
J5JN7a7DflsrfazivLgcMjqqc2YJKnfUCCX12D4/cEvXq1EtZavn4/+rvv/mhlzS
TbzpQJU6bVGarxClnLAw0XmLL6DG55TR2F1gQJEzWkv3DlmKdoZ+GA+wix/hMwOu
cvPrEK7NJ5Mzr8x2U6cnl845xZzv6SR8S5kb2x1TBtXR5Op285ztSaHlvhtymYfF
W9scZYVFplv+RJXdgku9HYK0icfVIV9qidc+dv+mxT9TaJZ5yad9QL9HynW0dN2q
HWTATnwwK6P26Eksp0dwG4HxugGLer2tWhYTnwAV0CaJIo2oKE/sCmLLNvpd/BoU
7iBA4B9kpCXS1TT6hxDKY/b0H2CWOjfsM+y0HOW4r+Ac10YTNZJccsPcrPOS47Fm
fnrPkezsucaZhNK/n324jZX1uPuA0e45etD47QrYSOyk8VD7AV4Ncp0J5l5Egkcs
ldGf8EaILMHIybAGdP7POgGTg420BC1/Tpm2MF0/wxIDn9cgqeqJj1DyU+HEDP2G
54Ac2rtDcGifQrpadLg8sLeNICGWfzAIm13kdZIH1J5PCursekZA2u6r7IA3nPxO
wvoRlj9WsU5ZAbTKbfmfCJ/kzUSCtW4YsFO66W9wJl8feUlwUEcRQrFTTUrX9Ld2
+qy6TL2YWwTsSRhUPvK8
=YC2m
-----END PGP SIGNATURE-----

--Signature=_Thu__3_May_2012_15_35_10_+1000_3anisiSgjMcOf=EQ--
