Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2BOE2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 23:28:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49184 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab2BOE23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 23:28:29 -0500
Date: Wed, 15 Feb 2012 15:28:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
        James Morris <jmorris@namei.org>
Subject: linux-next: manual merge of the akpm tree with the security tree
Message-Id: <20120215152818.58f32cb975a52a28328799a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Feb_2012_15_28_18_+1100_OPoy1uMYAb3GKpQU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Feb_2012_15_28_18_+1100_OPoy1uMYAb3GKpQU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/sysctl.c between commit 404015308747 ("security: trim security.h")
from the security tree and commit "sysctl: use bitmap library functions"
from the akpm.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sysctl.c
index 62538ee,cfeb1fa..0000000
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@@ -58,7 -58,7 +58,8 @@@
  #include <linux/oom.h>
  #include <linux/kmod.h>
  #include <linux/capability.h>
 +#include <linux/binfmts.h>
+ #include <linux/bitmap.h>
 =20
  #include <asm/uaccess.h>
  #include <asm/processor.h>

--Signature=_Wed__15_Feb_2012_15_28_18_+1100_OPoy1uMYAb3GKpQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOzRiAAoJEECxmPOUX5FE+VsQAIEhQ6To8ZOejwP7bB4NVVID
Km3DUBXnCDwB80czg/UB1NHdkgYHb3ePwXnwhcCV5bgnd6q6ki/4jzTfqPeD/tCX
5eXswZH4tqG7V8+fZt5XyXZ5YKaDoZOq5OvycERS9UxAMdOSdRPsDfVgGOX3G0zE
s60/ebShAYsJC0MaT1Q90zjnr61kSytrL2ujxhDQ6zdxFugQab7npulr6eOfmj2B
GbK5F3rLkbe8Qtye/IyDfUMuu5EOOf9spBbn2DHQ7bxh1ly7H/mN9UX5IFNx7Xp7
j971eANAp+GVRUDYy8Q+HXiVbItonkq9Y6uXJ0sJwoelcRhrpBmZMLJKIzT6iric
M/L3Ln3Vxqa3z0NNVBig49eSDtuf2HuHWxmFy3SdA/YCz1HWSw9L1hBMhBZ/fgrD
a9se5/IGGPotiRVe4EYmTX4c/mDiYOPf15npUN3lTuRbWi/jmJTq/diqba1xJcBN
FTIzVpMPRxH1ZBWju74bA1qK4JmB3ZntvzM59s+4R6lhrlQR1yZVNde115YCwxqo
qwBcvRz4wghu26v1uvTXiteOAqaU+5pl+u6ynskjxHPf/pabxqGMEj0tM7ou5VA8
27wckt5eThpzA+2k2Kq5soI+NF2snaxizasgBpsfBXTqAHD2ui3YmLfMji4axOd/
R8R9dyYfWPUYKarqX2g9
=SkI1
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Feb_2012_15_28_18_+1100_OPoy1uMYAb3GKpQU--
