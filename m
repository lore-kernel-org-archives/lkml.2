Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2HUE55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:57:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60743 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2HUE5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:57:54 -0400
Date: Tue, 21 Aug 2012 14:57:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Matt Turner <mattst88@gmail.com>
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20120821145742.8f4640e49ef079d83dfe0ba4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Aug_2012_14_57_42_+1000_S4X1_.F84otUHhpv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Aug_2012_14_57_42_+1000_S4X1_.F84otUHhpv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/alpha/kernel/process.c between commit 28d353d9891c ("alpha: take
kernel_execve() out of entry.S") from Linus' tree and commit 68f596a7a045
("alpha: rewrite kernel_execve in C") from the signal tree.

These appear to be the same patch with a slight difference in this file.
I just used the version from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__21_Aug_2012_14_57_42_+1000_S4X1_.F84otUHhpv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQMxVGAAoJEECxmPOUX5FEwMQQAIfTvDDTJfkAn+A2eO0JE4VT
n9Q3mnxZPK8k16YPEiyBzuwUljvkzvy0B7G3UJUjjGAZWcpZG54mvr5xyoXPyiy9
C/RXHWMc51vgxVGod3C/3j6hC6enWTpT6J8PKD6T/L4D4m4pgLC1Hm+b7Qng6IIF
z2rFWq4giZ53n3g5Fwr7tFCJIUFJLuSp0LEpBM+oSLNoO+sAq14hatuM1aGq62jK
vS6mKtYr/9/TXvpS6rSvBSuamaw+A03gDEs9F2A4Onqc3sK8+uU0qWhz+9e/pKQu
MSmgYqo2XZdyDCbbK06A0RMZhD93e+6KpmiOA5gaV75Xx4kdLGSPGQUolnaoKd7W
GCKhBfGbwFH1EzlIg9uFFIo2sJSlDFBX4k0PH6fMJt0b2dyJrdf/bl7xL0HQ5yof
6af2jB1dAXUfMndTH53aljzkhWl9ROkgGBcrbkiyg+Y0jqc49BaZeeNuS7QbuNy4
+ybKxYexngGNGjQ772hbJsTw2s8s7PiZf4j7Rnbpx44w35Y9Dw8vddMqcpr477Tp
6L/a38chEEMQbx4g4G8seMcttUENX5M0j+uUX05BGwib2z9KkssTbFMd+RB93+JD
0mIe7WMUaMNBNsNarPeVy5oaJFVrMvMuvtjUTzawkBc6hpadWRCrsY0cpLs8vfCA
nWoAQD6bAppZSrcBc4ZV
=AKu+
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Aug_2012_14_57_42_+1000_S4X1_.F84otUHhpv--
