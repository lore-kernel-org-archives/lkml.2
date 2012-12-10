Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2LJJD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:03:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54588 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJJDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:03:25 -0500
Date: Mon, 10 Dec 2012 20:03:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: linux-next: build warning after merge of the pci tree
Message-Id: <20121210200321.1343445856179c58d0d0cb16@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_20_03_21_+1100_5+yGN7sv+yv87Nhr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_20_03_21_+1100_5+yGN7sv+yv87Nhr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

drivers/pci/rom.c: In function 'pci_map_rom':
drivers/pci/rom.c:125:23: warning: cast from pointer to integer of differen=
t size [-Wpointer-to-int-cast]

Introduced by commit 84c1b80e3263 ("PCI: Add support for non-BAR ROMs").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Dec_2012_20_03_21_+1100_5+yGN7sv+yv87Nhr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxaVZAAoJEECxmPOUX5FECnUP/RhAlR94yz/bQlzHLizRwnhh
kRKWZ0DxsYmEtt7RKJ28XhqngisaUKqjP9edv84FC1enxDtY1249zibvDpVwXQHH
iLMYdcKOGLxjdymC2txgpL6AHKMC/t2flLtm/8iuGzoc/FplgU+UEqmTjlOWASR4
AGjMo42Vjj+Fl1hHQSVs8dl+wOSJiihfCWnwILolUB1x61mVVdNxKhsmooDoowwP
53COEVO2erPpsi90mkO+z9HWn7omNaRwFv6zF+I1SHbz4e7+oDdq3wLxDbbDNWCR
KyVWQIJ6kLla62Y/WHCq6lhxdnSxdesoLK/KmlrClDR94Fy1tfmrgoTK1K+3viyF
uxSlNb6x+2jWzBl+HaEPKb9drsOc4wTkEcZJ2zPgssMuTaOHyWLRmR5iGxGPtllx
WrC58tJUZBzt7NG56+QhKSfnMB+lxRIHZr68vaCfr6AL8LbOvxnM6RTUrKK4olc6
Mx+sYOsIU6DVeb+QrkPoBB45/IKPGad4tnS6pRWw/kV9ky1nOydkAsUjAUpgyU73
F1SnTdLL3YOnpcFrBQF35mZkd/MBa1qTXaE3Cvc+pGBxkdvW92l26bO/zji3CiNm
YSShWPQR+uxobmd0PGQ0YKxl8kn66SQgk8tECANt9E4ZBV2gaq+qWuIKbWNyykE9
GEeG4utOCoV8ywO7bY3M
=FYN5
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_20_03_21_+1100_5+yGN7sv+yv87Nhr--
