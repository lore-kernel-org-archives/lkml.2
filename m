Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2HMAkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 20:40:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52463 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2HMAkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 20:40:04 -0400
Date: Mon, 13 Aug 2012 10:39:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>
Subject: linux-next: manual merge of the rr tree with the xtensa tree
Message-Id: <20120813103953.f6ea0d4a0b2a1cf734d6cef0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Aug_2012_10_39_53_+1000_i8S8fhM9U1J3GeHR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Aug_2012_10_39_53_+1000_i8S8fhM9U1J3GeHR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/xtensa/Kconfig between commit 75ad645a6efd ("xtensa: add missing
bits required for pci/quirks.c") from the xtensa tree and commit
d673c23ca730 ("Make most arch asm/module.h files use
asm-generic/module.h") from the rr tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/xtensa/Kconfig
index c161367,516210a..0000000
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@@ -11,7 -10,7 +11,8 @@@ config XTENS
  	select HAVE_GENERIC_HARDIRQS
  	select GENERIC_IRQ_SHOW
  	select GENERIC_CPU_DEVICES
 +	select GENERIC_PCI_IOMAP
+ 	select MODULES_USE_ELF_RELA
  	help
  	  Xtensa processors are 32-bit RISC machines designed by Tensilica
  	  primarily for embedded systems.  These processors are both

--Signature=_Mon__13_Aug_2012_10_39_53_+1000_i8S8fhM9U1J3GeHR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQKEzZAAoJEECxmPOUX5FE3mQP/2sOx9VX+kxPzoMGzYJu6kmj
MX856asfHzo0WzKyzshTJ+T5H5B6VwcjfWIZjvQ22yRNmyoT+TL34pAZADnakbPe
j517WGYgw6C13VaU1cj3nsNqnmc5IJ5GsOa2o8KEsUg6rw3j3Y4l0HSri2elUZe4
y1icV6pKBg9IP+TDHqnh5F7CyHQz1Ywy0O05vfCUPlIjJMrT+WPQmSSVVtR3Iszs
QgNeUoWGdw8zJiS80RGBiayDRYoA7OWrm2ydFOFIm6nEkSxdTYDXAlhXz+4lVBp9
31cj8FpqQrkRSCIJXXzirjoG/VNX45ix3e9jfQHL74/tUsFE2baw8DwbbVmTNhqL
h8H8ymOWj2xsZfYkYXvkXSYFR4jvDga/CDtIttAHo/kGOJc5qYkOJAXtalgylktf
A/LQyWzw+o3BGyYuueM5EbIS78FmZuDQCvbfoEY/+U6L9DxK0ybip5UVyVrNsVqi
H9kw6ZZRTu7uRmjHxeK3bBDSXQ+jraDhAMF/cS9DhcJOaGDho54AR2iKPKXkk5+1
+1CAuFEgBYRzWL9nbUblZ4IB9Z6q0hYUVxr94sgRFc7K1gZYis3ehqMn1hZKZDHS
JQOQiXbztyaDgKH68Ya1JGM5aNWA2tibLBXd1U7RdnQ9K2gOsDOTEjz+vXYXTVu8
wvNhTx6cl92vJ4w4UMaw
=mLf1
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Aug_2012_10_39_53_+1000_i8S8fhM9U1J3GeHR--
