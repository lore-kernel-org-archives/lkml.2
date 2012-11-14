Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2KNEH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 23:07:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46202 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2KNEH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 23:07:57 -0500
Date: Wed, 14 Nov 2012 15:07:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <florian@openwrt.org>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20121114150746.433de520ffbc71b4281f3c62@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Nov_2012_15_07_46_+1100_RVFDQTh15FtgVMDX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Nov_2012_15_07_46_+1100_RVFDQTh15FtgVMDX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got conflicts in
drivers/usb/host/ehci-ls1x.c and drivers/usb/host/ohci-xls.c between
commit e592c5d0b7db ("Revert "USB/host: Cleanup unneccessary irq disable
code"") from the usb.current tree and commits ead92fae1290 ("USB: EHCI:
remove Loongson 1B EHCI driver") and c2e91e046df6 ("USB: OHCI: remove
Netlogic XLS OHCI platform driver") from the usb tree.

The latter removed the files, so I just did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Nov_2012_15_07_46_+1100_RVFDQTh15FtgVMDX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoxkSAAoJEECxmPOUX5FELV0P/i1e1DvYFqOPwEsF3in6Eu//
EutvAuS5jrBF+23G+pVPg8J3TJxM8QFMzWytsKrF4rPqaGr795OjIOj+s97I/fcR
6qsa3RpQhChZrK+I7on7jbTjMKMCyGQ4Z8GWYcgthZZgBoKCWc57N4+yccLOQAUf
A4utQMWCs3oYBGN8JaRcIhMMMbtg1+zyM4H05pJ58vv5+FpJgPeuPfgcLTGVFBmZ
QweZvnhrhGW51bPty1DiKo1tHwaGpyn81Wgn7myN+BqXcg9J+b5ZtZFzmDuV5AGC
JjyCYqsW9IrYFjm3t3OdeV4AWloi1xS/9OqB9Px8ssplN/vPEkVDsJLrN4ppdxbP
6RIxVM0XrKPOomSnFdNxiksx2SqJFrKyikyp9hgUXAa6MY41/EGwEshPXihsAo8X
u5QukYUQfJ9++/jbQgEEmR0VGtC2SjbT/AOvF1b1hyvXii9crX8P7ebFCL2QrZj3
i9UdTvPq/NJ5nD88JIgXe+g+gxUW2wNVagqVCa7TAB9qrDvsliFhhkXQZ8Tmclox
44scOGTQT9QYfVqV3KiRV35xkGZvTFSyc8+ZWCZScRE1Y6WliPg70sP/35/rfl43
bG3MHaUYu7/537y/DA1V5YpXAChEZ7jbD414gaEPm4odHVuXxqGUiht4CF4Xx2J/
jtGO7sOZM08cPLAMxj7q
=UAuF
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Nov_2012_15_07_46_+1100_RVFDQTh15FtgVMDX--
