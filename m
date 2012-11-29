Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2K2DZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:25:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52986 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2K2DZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:25:40 -0500
Date: Thu, 29 Nov 2012 14:25:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: linux-next: build warning after merge of the xen-two tree
Message-Id: <20121129142530.37630048cd37048f884b17e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_14_25_30_+1100_BcMX8+GlK5FDxGEQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_14_25_30_+1100_BcMX8+GlK5FDxGEQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the xen-two tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

arch/x86/xen/enlighten.c: In function 'init_hvm_pv_info':
arch/x86/xen/enlighten.c:1617:16: warning: unused variable 'ebx' [-Wunused-=
variable]
arch/x86/xen/enlighten.c:1617:11: warning: unused variable 'eax' [-Wunused-=
variable]

Introduced by commit 9d02b43dee0d ("xen PVonHVM: use E820_Reserved area
for shared_info").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_14_25_30_+1100_BcMX8+GlK5FDxGEQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQttWqAAoJEECxmPOUX5FEgsgP/2fwgDauJfqjC6FrQGWbNFIW
gM4KvnMNlSnJ6W4AHG8bbdEDO6qNTJVDFIBJaZY4AwIvt9gk3XAUpo/Dwhndtqcz
It+CFCy4ZKlsJErSXMd6f3ttXeK5dtpr3+d1vzE7ao2Un4F+xm0wJwoHv98M1oMs
vyfLhaG4YdplVHVVL8LGyt3Pz1+1G/k/Zc7RXVVZjCzQoSUzhBngFE3pmAQu6E6Z
vfPWiMubdy3yFKuU3BN6svFvVC0T/v9Y+C0TqQqdi9kpsj4J3AEKoJMF6PoReL2d
/0hsPegmkLWo96vmI9fSaKNpYNQ6xUOzUI4h3jh+W+NJqgm3Xx5V4K/l+2wjAHF+
87+GQySctPmg5DGtONmDJKxS2jDCrNZdXrNWOSVrTwBR8p9sLvoVV6WOLF5Pcocn
er9tIhfBejIAdZMzR7kNIiu7VI4IwsDTh7LEcF6gik8Dy/Gosd/f2NJ3n5PH8PLj
oIw9o9Yy9VaQRROxjUxb7OXs6ShWQeHG2VBo0g4pQlysIuDgLnDeyRyHVcEmTA0U
/GKji5m+n8qJbOCF2dGiZG9Bw8ERm7SMwFgNdY/jsX3eE6HF5SiqqrSMrCogk2by
eTDiyd58JBEiyIYaHdYoL+961/UQLAm22ks+kZZvGi7jQqZb+YmTHMsVm8xIogfG
MreTi0ydgN/u7N/bqeX/
=Z6b9
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_14_25_30_+1100_BcMX8+GlK5FDxGEQ--
