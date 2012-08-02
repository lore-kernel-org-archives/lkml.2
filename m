Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab2HBEEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 00:04:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57978 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2HBEEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 00:04:38 -0400
Date: Thu, 2 Aug 2012 14:04:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20120802140428.f045d5eb03bd2a5e03a5230d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_Aug_2012_14_04_28_+1000_WBWKaM5D6RfTqI.L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Aug_2012_14_04_28_+1000_WBWKaM5D6RfTqI.L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
produced this warning:

mm/shmem.c: In function 'shmem_interleave':
mm/shmem.c:1343:9: warning: assignment makes integer from pointer without a=
 cast [enabled by default]

Introduced by commit c3cfa3129c03 ("tmpfs: interleave the starting node
of /dev/shmem") from the akpm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__2_Aug_2012_14_04_28_+1000_WBWKaM5D6RfTqI.L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGfxMAAoJEECxmPOUX5FEsrcQAIfvnMR6mbvBQ8JFRw/8Wm54
PpekKD98RgweLczIJBgKk93bQhSTi5cHwe1XbB/seDNarmZbHzikq9UbWZb+JWwX
yUIw9/g3doi3aSMcUtxkhA+cJpDuENUg2Y+JHjAgYg5uM/QOCRVmYAar1FZAoLtJ
W7zZOVEq9VXSRegQejhhRKKvFGS+GnZVcKiK9++PP2jxNoKrQ/AkarNon4TJHtSN
eKkgGBp/zjF/vbR8vq3dpKSG0FuD8eb9l+KxdRq6a3FLFtrRjiIpd2/CzZEBFwrz
DW9h77pwPnzKpLBxVjdidoFbBIDKp5YufBt71hF0SViCqkTGDa4FIHF7SJJ7jaZ4
B+b4055xqlDS2qqecmgXry+zzIF6rc++ON2fFh5luEJDxtmatNa0OOt2lYD//Ube
KmfH/gUOATFhe86qAmV/cZ/D03muh/q/5SIKtar6FZYto3nkY/c3UzOYsPsopCly
EykyON7zgltFUS4qpMNA7wHxREzBcONv+bXnnQiY7FiOi2/kiJfDz33q+ppf62sQ
YB8nEOmZGPrY7hW6yaVhNm3Rp/7Mfa1r7sbj0f5g7mXwI9+qq/RU3XdFWyZMWXHR
xFdf7LeGg9OQ+DMQiY41J5LTkPtBBdv5dv7RVqcP54S+gbD1v7WN2o6IPRXQJL8O
NkBhtCaw2kzOdgMwMC+V
=sQdr
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Aug_2012_14_04_28_+1000_WBWKaM5D6RfTqI.L--
