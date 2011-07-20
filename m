Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1GTDCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 23:02:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35803 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab1GTDCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 23:02:03 -0400
Date: Wed, 20 Jul 2011 13:01:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the of-pci tree with the arm-soc tree
Message-Id: <20110720130152.1e2f099c084dbf22e55d2a16@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_13_01_52_+1000_RhkGCb6mPRP2q5.W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_13_01_52_+1000_RhkGCb6mPRP2q5.W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

Today's linux-next merge of the of-pci tree got a conflict in
arch/microblaze/include/asm/pci-bridge.h between commit f4ffd5e5dfda
("pci: move microblaze and powerpc pci flag functions into asm-generic")
from the arm-soc tree and commit 72bdee79f89f ("microblaze/pci: Remove
powermac originated cruft") from the of-pci tree.

The former removal removed a superset of what the latter removed, so I
used the former.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_13_01_52_+1000_RhkGCb6mPRP2q5.W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJkUgAAoJEDMEi1NhKgbsDMYIAJWFAEfC8BbFv3A4ktyhDW97
p6CIqVsIpD/HDhXFBV5GJXj0zJYhUbC4TTfqcfQTO1MFxObkNdcwJwmvvJ9Z51ka
NZ+SNnoA8U0NfFSFaZs9Pi3KtGokFCHgrFncQKzVsphDNUVYfItN+c0DEvbFbiSm
hhI7tDjcTncWbxsKvmqVNN9B4xKSeywZ61h6TFqfa+BYDkCg0EY21PHAcjn3wQ7X
nPMRb/VUGosGiRz5CIXsKbf1CzlwdSXeScP/hen/NYCtFcn1ocF8imjJ2xsWWMDR
y8imUSTSDVEtMApnpxB7B9CmfbDAQQ8q59CjI7jp5Ll4PaBtvWWYwt2n5ZziSlg=
=M24m
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_13_01_52_+1000_RhkGCb6mPRP2q5.W--
