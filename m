Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab2JLAPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 20:15:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59367 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2JLAPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 20:15:00 -0400
Date: Fri, 12 Oct 2012 11:14:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>
Subject: linux-next: build failure after merge of the l2-mtd tree
Message-Id: <20121012111451.ad2a5db59d470cf24393226a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_11_14_51_+1100_/M/NJYAjzvh1g4TH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_11_14_51_+1100_/M/NJYAjzvh1g4TH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the l2-mtd tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "denali_init" [drivers/mtd/nand/denali_pci.ko] undefined!
ERROR: "denali_remove" [drivers/mtd/nand/denali_pci.ko] undefined!

Probably caused by commit 305b1ee29c8e ("mtd: denali: split the generic
driver and PCI layer").

I have used the l2-mtd tree from next-20121011 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_11_14_51_+1100_/M/NJYAjzvh1g4TH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd2D7AAoJEECxmPOUX5FEvgAP/1K9kcPD8CGYwXM6Q1mlT9Ev
V1ooX1qZL52Tb9GlMPh/XQ1cvcPznj+zh58OXCIKl6e+JIHdSwDnAhQjOK102uag
XVh+qo55JpNYVP+X1u6cpWnaSZegbZKs0qrJOeWmxqssqkqc0vEJ/luMdH/VDlE5
YtzobhBuGafKr1XYPnVdePgYf7d4Q7jGPc7ZrtKX8QsGtbjCWlPNpkqLLR8F+4sd
6iI7eMAqD31QaJ2YDPr4aM/WaCGJUBZfLThafKUqwPea/0EEqS+lri/ke2ZVSai9
ZTP09H1kaTJXjJPzLZxmGi9CfPjmTWYcgaH0Zw41RCshm9LRApCBblSeqOIYJQr1
d9jrKF3x8K+8HQf8EZVhX3mBVJcV6XkVFmBE8bF1esoJzpCebcJ0AYDOawg05DKv
RrNq4Ou1Wk3n4dKq9l1Gy4qZq4kCCuK+Z595+WugcTpgRz/supwfOG5PZ1qo+99/
MdxxtinTzEIFLdGfKTzPdCoHDWYqn9/LyAbuCtITrQDi6MakPnSGPSrvGIRv0p09
q/i87+UZbp9L1fY+XlTDdHe4IjMc0IgBeKp6cQKKNfnNwFpJzm0FYmjxv5OJvWYW
46PnRBK/kTmIRT1xZBVyY6AQ3HXYcIxVDPCNNPO+picqlNQSfoYZO7dABqn3P8kD
zpqBGkFnLlAEagncok3V
=cOXV
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_11_14_51_+1100_/M/NJYAjzvh1g4TH--
