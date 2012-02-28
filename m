Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2B1CG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:06:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60323 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2B1CGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:06:43 -0500
Date: Tue, 28 Feb 2012 13:06:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the devicetree tree with the powerpc
 tree
Message-Id: <20120228130634.3c511b096bc78f9b99e804fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_13_06_34_+1100_zokU8=7auXN9yyRV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_13_06_34_+1100_zokU8=7auXN9yyRV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/powerpc/platforms/iseries/Kconfig between commit 3d066d77cf46
("powerpc: remove CONFIG_PPC_ISERIES from the architecture Kconfig
files") from the powerpc tree and commit 0f22dd395fc4 ("of: Only compile
OF_DYNAMIC on PowerPC pseries and iseries") from the devicetree tree.

The former commit removes the file (as the legacy iSeries platform is
being removed), so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__28_Feb_2012_13_06_34_+1100_zokU8=7auXN9yyRV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTDaqAAoJEECxmPOUX5FEGbAP/3JdMyyxVFac+ddRSktCQKLh
fQJVx68d4RGVEL7+7feXnsVmokACmSa9Q92s/BDjVIAaDatwTG+mhYxGLb7oKN5L
dX8Gap3ncFAfTNMfwNz+fYBuIMFu7B1BTaC2cSjYVT4uPMNMCVA63ntjr+KC8Nyp
b6wXS5L/lJvFlCnlbGaMc+ECwg7GkS7szez1lkuTV5cFI3Xc4YuTeMRREyF2qBcB
CNqjbjTnvusZtqeTbZIFEicMfveYtukMpC0Y13HXKjqJh6z+y1ZVvcMtUEzyQUUj
+r9XoM099P+zQgCj8vp3TEhpj/4b7CFnKb4PH28BeJ7cbl8wAyQtNz/mQS8wZd+P
FrstW+xDnxs/OIEPeyhjZ9dC87QcMTBH31yibpfekcwhO0dpSNLa02PlKbgmg5nu
bvXv2lZvpq2Ek1yqYAH/Vd0NP+KhT+UXgg9MULT/ZNtu3ivV0yo0tfN8URCKvfUM
SeO8lA/TBP+MPcSAMD29qwKKkGsNgEGXT85mKH55i8iSwUAlpcNjsGwrZJM3VJ9X
t/debZfDrG3cnIxdK61ED4X4qugeWeyISnjKt9W+UtnQNaVDRwAJnU5sFdmdXfVu
l0f6OjQgJL0DgvIf1Anza8m5mKFOdhC0OLGeLLzgi5Ewzw1yyVoMKRTi8LPcMMkC
/tFGkGd77s9YK2RYTSmf
=bAL0
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_13_06_34_+1100_zokU8=7auXN9yyRV--
