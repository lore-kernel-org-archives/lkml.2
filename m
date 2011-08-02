Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HBAsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:48:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52686 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab1HBAsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:48:47 -0400
Date: Tue, 2 Aug 2011 10:48:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Mason <mason@myri.com>, Jordan Hargrave <jordan_hargrave@dell.com>
Subject: linux-next: build failure after merge of the pci-current tree
Message-Id: <20110802104838.ac7f46b54e8a3fcc4cdd9448@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2011_10_48_38_+1000_6lB1GDLhmK=OoAsN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Aug_2011_10_48_38_+1000_6lB1GDLhmK=OoAsN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".pcie_bus_configure_settings" [drivers/pci/hotplug/pci_hotplug.ko] =
undefined!

Caused by commit b03e7495a862 ("PCI: Set PCI-E Max Payload Size on
fabric").  Missing EXPORT_SYMBOL?

I have used the pci-current tree from next-20110801 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Aug_2011_10_48_38_+1000_6lB1GDLhmK=OoAsN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJON0lmAAoJEDMEi1NhKgbsjsUIAJ/AHpzxwYvpghrhFTvTcBz1
NfuJgG5Y4QcZKspW6802iCbqQtXmA8J1v4T3SOOoCx3A5hAJbNgXEeyta0a/xSsZ
HopZEqxaKw73kxUhf//SAjKpHPByDLDcv9tLN9COBs+cXEBgxe79X0p++DeF8n1k
7dP+jI3dz4ZT5ClZ4rZSs3zigO/eSf58jO5lBKKGnEv5ku7WOiM4yExPLiNnmKSU
YJ4SdGHJS5Jizllz6ET12geiCZqpHtQT8wFXAKsXMWIX+Pnmgd+yVp7hCdtn3UQb
b1NPRNxgVG3j/nytkM3FuOeVS+dZP83aw+wAxNhL2IrLC5qvU2Ot2uP/sQONvT4=
=0qtY
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2011_10_48_38_+1000_6lB1GDLhmK=OoAsN--
