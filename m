Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1ELCO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:14:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59600 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1ELCO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:14:26 -0400
Date: Thu, 12 May 2011 12:14:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the drm tree
Message-Id: <20110512121416.bf2f2ea6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_May_2011_12_14_16_+1000_KYXic/DA0IXG/WIo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_May_2011_12_14_16_+1000_KYXic/DA0IXG/WIo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/kernel/apic/x2apic_uv_x.c: In function 'uv_system_init':
arch/x86/kernel/apic/x2apic_uv_x.c:815: warning: passing argument 1 of 'pci=
_register_set_vga_state' from incompatible pointer type
include/linux/pci.h:1085: note: expected 'arch_set_vga_state_t' but argumen=
t is of type 'int (*)(struct pci_dev *, bool,  unsigned int,  bool)'

Introduced by commit 3448a19da479 ("vgaarb: use bridges to control VGA
routing where possible).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_May_2011_12_14_16_+1000_KYXic/DA0IXG/WIo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNy0J4AAoJEDMEi1NhKgbs4AwH/1ejr+uJM0RBYsGWLvFjYOKc
z5JsB9zotKcqJzbUPf7c0u3Ptvf0fnwrgmyzTv2qCdYY88VUXDP8tbV3QYhYSnYr
JlAjZDSx8Ue4kDgby69oYQ1WSMh4a27P0nVL4xUVwnRsQYzOjMAq1jGWCUG7WYUm
BkGnvswVpXii+ujcU+/YYpHQV8qLYy5v6A8gYFcjvI2Ndvc9u2s2HdGZ+s0DO1Dz
UaLEBjQOMce5EJc4XkIE9Dys+yF5NFKNVDHnUnUD/0NJhNvI+se5av1s18Ak33jF
8tGhVFGL/d57YVWA2Key+RayAJjjGvX2aY89SV52+6q8ZNFs4IyOK2bp5dJ53qc=
=y2ED
-----END PGP SIGNATURE-----

--Signature=_Thu__12_May_2011_12_14_16_+1000_KYXic/DA0IXG/WIo--
