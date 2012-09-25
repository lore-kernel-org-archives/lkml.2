Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2IYGOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:14:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52798 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2IYGOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:14:05 -0400
Date: Tue, 25 Sep 2012 16:13:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Durgadoss R <durgadoss.r@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: manual merge of the staging tree with the thermal tree
Message-Id: <20120925161355.06cfe875c78bc163b050ed8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_16_13_55_+1000_uzzgsfx6ymwvDcjX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_16_13_55_+1000_uzzgsfx6ymwvDcjX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/omap-thermal/omap-thermal-common.c between commit
82d3a76a88cd ("Thermal: Pass zone parameters as argument to
tzd_register") from the thermal tree and commit 765a1939a364 ("staging:
omap-thermal: fix polling period settings") from the staging tree.

I just used the thermal tree version and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_16_13_55_+1000_uzzgsfx6ymwvDcjX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYUujAAoJEECxmPOUX5FEJlUP/A/srLjaEftIO0TvlYCPyaNU
S4Mn7+uIvWrBMp28CqfkTnRfs8JBBvC0wh3enVteFydCbTbeIXqHy24Abm/4vI3C
erkASL0RpMalbn2ondZceJxU0VQ7aycLDkZE+IAc/lzCqsA5Xucs+VJjYeiY5Emw
J6pPiaDXvdb1uVocq+q2tiKCBisSlBIyp4rhIY+M1SizqipAfx/W7PcuSc5Xkaym
+OtmgZlpvkufLUmTnCVwChsqkYAiME8lIBomrEdyem5R44TxaBLHtV5vZNdDFCKe
p1IgoBCjsevUhtqrdfhGefCQWh5vb++0RPU226Xr4fZy2vxOgjTZNkmjOIskVRyu
5JDolGzk6C3EahuTV9pdcu8XKNA5LwwcRmvsSb/YI+Ft8hS9erLF90CzVMJta/KA
mjohTmKozv9XKfgicH4634GSmfzY94nTAIk2iFsXCg6HzU4vkyzZwpWhPWHgzEg4
+o/YIz8idwIVS0ud92US4xJUUI+NCSBKLvOvovpDeppuwXHx5JR23mgt5Aq/mo10
mrj41Bwq9vHwAYM5eweUeMAw7VfybgEOWxdHt8KYuioQrXKQUgCxWxjyxH9ykN1F
1zqIwkhvXZydef4FzkEzCXkXfnSX/nVKlmqS/fcQQJE9KcVVBAeIUHRyTs34Ow54
B1GO017cgz2iNbs0T8FU
=FQsp
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_16_13_55_+1000_uzzgsfx6ymwvDcjX--
