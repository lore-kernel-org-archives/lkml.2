Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1CJAnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:43:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48747 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1CJAnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:43:22 -0500
Date: Thu, 10 Mar 2011 11:43:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: linux-next: build failure after merge of the cifs tree
Message-Id: <20110310114315.eb9aec89.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Mar_2011_11_43_15_+1100_p_jO0g5ZOu2LlNO0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Mar_2011_11_43_15_+1100_p_jO0g5ZOu2LlNO0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".set_cifs_acl" [fs/cifs/cifs.ko] undefined!

Caused by commit 30091b5571eb ("cifs: Allow to set extended attribute
cifs_acl (try #2)").

I have used the cifs tree from next-20110309 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Mar_2011_11_43_15_+1100_p_jO0g5ZOu2LlNO0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNeB6jAAoJEDMEi1NhKgbs4AYH/2xabeEUr0iCZVING14WMTXK
YjWC1i7ENdNMmeX0OrCNg2wc91uwydNK8sWB7/0TipTLOC930rIDcr2EOQSU+BGK
+4+gXyeh9EPi5OKSWxBee0s2je1QKS/NybURIA8nOpJQ27kgSzyqKBsBuy656hjt
MTTGbVrT+ky72/df9A4dehGU7Bgrf4fRALVqNVZUC3Dk4LZ19LyRtlv5ml4Xl24c
7YKQZvMj6yFfQdTKIttNyc4pykKAsZ59/X1my5YDRYo6NPGkNGlD2VZAAsRb7ng/
VltX9rRk4OSwK7kGE74BlvSXaYj68b9V3e/UtSMeZqyplOcwnFzCJvo6WdUVru8=
=BuHA
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Mar_2011_11_43_15_+1100_p_jO0g5ZOu2LlNO0--
