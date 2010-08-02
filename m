Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab0HBBSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:18:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46884 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0HBBSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:18:44 -0400
Date: Mon, 2 Aug 2010 11:18:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Narendra K <Narendra_K@dell.com>,
        Jordan Hargrave <jordan_hargrave@dell.com>
Subject: linux-next: build warnings after merge of the pci tree
Message-Id: <20100802111838.8a568df7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_11_18_38_+1000_lFiKVk0+g5WyEgDg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_11_18_38_+1000_lFiKVk0+g5WyEgDg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the rr tree, today's linux-next build (powerpc
ppc64_defconfig) produced lots of these warnings:

drivers/pci/pci.h: In function 'pci_create_firmware_label_files':
drivers/pci/pci.h:16: warning: 'return' with a value, in function returning=
 void
drivers/pci/pci.h: In function 'pci_remove_firmware_label_files':
drivers/pci/pci.h:18: warning: 'return' with a value, in function returning=
 void

Introduced by commit 911e1c9b05a8e3559a7aa89083930700a0b9e7ee ("PCI:
export SMBIOS provided firmware instance and label to sysfs").

Please build with and without the CONFIG options your new code depends
on ...  This adds considerably to the build noise.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_11_18_38_+1000_lFiKVk0+g5WyEgDg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVhzuAAoJEDMEi1NhKgbsN0IIAIXiI06nVCuYbCBlOmFzokWb
muX3V0cz6E0ZWmHTMBYZRttYGvqlwwDAPNZNicqc+aXomqSRuSRb/kvTfXrYIHd5
rrY1L+Ed165YMqXc2KyuVDLogRCKzyzITfwoq0nnS75k4Q3+wi83Yi4MpFLYdvzB
rQNKnVlglYqHwC576NS/ybmL0lRNiJA7LUwDUxmTs1vg3JJ0+nBGVAzFKk6ugJdz
kNbPVM8EQdxZFC3Mg1CCBuK0Sk8Gb5Sy2IHJOWJ78+IpYWvGlc8n/r95XtNZTrKs
nFwL5gr1+Qi8tDAk9z/HUiZR/kwuV9O+5x93GgrORcUyRTa+xJJEUQXLAh7tYe0=
=JOe4
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_11_18_38_+1000_lFiKVk0+g5WyEgDg--
