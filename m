Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2K1DDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:03:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60171 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2K1DDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:03:18 -0500
Date: Wed, 28 Nov 2012 14:03:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: build failure after merge of the powerpc tree
Message-Id: <20121128140308.abb21ec8f61553a2ed077fe3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_14_03_08_+1100_1GgkkmxpSg5YS496"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_14_03_08_+1100_1GgkkmxpSg5YS496
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the powerpc tree, next-20121115's build (powerpc
allmodconfig) failed like this:

ERROR: ".of_reconfig_notifier_register" [drivers/crypto/nx/nx-compress.ko] =
undefined!
ERROR: ".of_reconfig_notifier_unregister" [drivers/crypto/nx/nx-compress.ko=
] undefined!

Caused by commit 1cf3d8b3d24c ("powerpc+of: Add of node/property
notification chain for adds and removes").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_14_03_08_+1100_1GgkkmxpSg5YS496
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtX7sAAoJEECxmPOUX5FEAY8P/R5anO5oaEyz/wut2Cv7W13Y
IeKiNHSQiTMOg67qDL2OVxHh2PVCIhAFJ+T/Jo3RYuL99EYzW+qzYbZWjaIlzLE9
Zm51BM5SiY4aiDsUiZSqUcNnKkD+2IQy4idnri635FVGnHfy0GjhMifYhPzmgiuP
ncyUowEfsHs7IV38ObwUgBloEBImgzRg/kI0uffDBJ2cdHSEeIn4n1YVsaI1R1zK
cO2Huz/Uo3hBCWjQamsCaWXt6C9J7nqP8Qgicu21xyMvebKh5vRwroffPY6Q2XOL
Nz1U4bVak4/ARyZT2c3k6NkzqvtEDg8ccQF8l2zYDWk9strrH2Vpjvp94XOnzwY9
SrbSQORTsi6h8lN+ARNP9lIZTvtvcT7MQpUjHJNnrxU4J1nrbZFHVEY9Zc6LY6Vo
W7ZT4cBgnNt6SMhigk8ttjTopyFZd2bJoKQXrDYYHEbiD3Rmcj3zTQ0FpTRlJkp5
yJw9sIr/Fc2BSWdoVGvz35Z6+4JwpjmPc8KPpz/HggiTAbDcIV4VOB4bVKNpkKu0
POz/pc+8Wjb5uMVF4fBj6uq6s7//Mpp9GB+la8nKic3YW6Dyrca6KcPHHUu05Z72
qvpK+LuGZNe+J6P99ckAhCsaIU8g9HPAkHdnpByCP39zUuMqL2jsHGTl91NMcsI/
F78xkJoHXIPnixM9AkpN
=zloH
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_14_03_08_+1100_1GgkkmxpSg5YS496--
