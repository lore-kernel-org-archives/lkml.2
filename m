Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1IQLTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 07:19:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54966 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1IQLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 07:18:58 -0400
Date: Sat, 17 Sep 2011 21:18:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110917211847.d6e0e401b06707eacccdf1c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__17_Sep_2011_21_18_47_+1000_/sc5siKLc5uUrSw8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Sep_2011_21_18_47_+1000_/sc5siKLc5uUrSw8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (i386 allmodconfig)
failed like this:

drivers/block/mtip32xx/mtip32xx.c:95: error: expected specifier-qualifier-l=
ist before 'compat_ulong_t'
drivers/block/mtip32xx/mtip32xx.c: In function 'exec_drive_taskfile':
drivers/block/mtip32xx/mtip32xx.c:1631: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1632: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1633: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1658: error: 'compat_long_t' undeclared (=
first use in this function)
drivers/block/mtip32xx/mtip32xx.c:1658: error: (Each undeclared identifier =
is reported only once
drivers/block/mtip32xx/mtip32xx.c:1658: error: for each function it appears=
 in.)
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1663: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1668: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1708: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1729: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1871: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1872: warning: cast from pointer to integ=
er of different size
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: warning: type defaults to 'int' in =
declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1922: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1922: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'out_size'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: warning: type defaults to 'int' in =
declaration of '__pu_val'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'
drivers/block/mtip32xx/mtip32xx.c:1927: warning: type defaults to 'int' in =
declaration of 'type name'
drivers/block/mtip32xx/mtip32xx.c:1927: error: 'struct mtip_compat_ide_task=
_request_s' has no member named 'in_size'

Caused by commit 49fdf3a7c4cf ("block: Add driver for Micron RealSSD pcie
flash cards").  Sorry I didn't spot it earlier ...

This driver assumes CONFIG_COMPAT is set.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Sep_2011_21_18_47_+1000_/sc5siKLc5uUrSw8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOdIIXAAoJEDMEi1NhKgbsBnEIAJbNym2DIe3Kntwll3kF8nzr
nTIZ8+PoComMbcb7NdkALVyvVWtSF3HEMPVEjzEH7MKUE90CGkVfxbeYXsHjpt3O
NCjSdT7xUzl7Jzetu3wj8CtwLWWkI7V+vGwXmNrSzOnbdzlXhucPuNzEIWtprnIJ
FxnxKU7nr5g0PrNDBWN10/bGgtfQs/LmwxuRQs4YBCLNMdB0ka3rQu+zyafJw3U/
Lkquybx6QRCeIEK84+ZrRSxPbsnG4gynWZ1WalmQyrt0O/ObCDidO8O9dtkuiNRh
gK8MndkilRKs82XsrQ5joluB18N81P00YzGqi6GPb0o1aR5+sv+zEdOWuAgbEFM=
=qS3/
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Sep_2011_21_18_47_+1000_/sc5siKLc5uUrSw8--
