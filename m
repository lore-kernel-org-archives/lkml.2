Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab2KADqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:46:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53205 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2KADqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:46:03 -0400
Date: Thu, 1 Nov 2012 14:46:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: linux-next: build warning after merge of the tmem tree
Message-Id: <20121101144601.2e7dd92cca17f80f368bb012@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Nov_2012_14_46_01_+1100_DNkW4WIlpo+28ze3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Nov_2012_14_46_01_+1100_DNkW4WIlpo+28ze3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the tmem tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

arch/x86/xen/enlighten.c:109:0: warning: "xen_pvh_domain" redefined [enable=
d by default]
include/xen/xen.h:23:0: note: this is the location of the previous definiti=
on

Probably caused by the merge of commit 6056726e851a ("xen/pvh: bootup and
setup (E820) related changes") from the xen-two tree and commit
7282a68f5aea ("PVH: Basic and preparatory changes") from the tmem tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Nov_2012_14_46_01_+1100_DNkW4WIlpo+28ze3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkfB5AAoJEECxmPOUX5FEPV0P+gJ8AW7TnYW0nps+pTtAUSVP
1BnnYSyjVDGGt/2BuVaHayge+U16M+5VC4qtLdV+hxj2nQF9P7EHjTqrcEIS90bZ
yFRAuQVMxbSqQ6NMY9eV3j24s1SFbZ1WVMFXaLL4WfCbOqQGcCzleGcCfVcdeLQR
KQcU2qsvooFXrFZNzD9LGjI1X18f0la7pBc6Mntc1gnYy0N8v7k1unM4pVv0j31+
zYhV+66M55mPZAwuEpGf1/sg+UvhiatcWypowogz195tjBOUXPwwu5H5l1boJvCK
lScswFEvDb80Fw82Wa2m0MO3ccaxKFqiqAreDhI8Fj65PiWywMoRhw+zW/zEg9Ga
F3rd8vDNffCvp3kYqvNBsTzzXIxzO4NiyqfBsy2Fh3jz0qWMKKZT22WLXmYBnRTs
poo7i/fDXP9ExCMdx/uVr5QD9VpbXSbS/Wie8g5Sf4lTfM+CLASsDwa542OHWyQH
et9R22gZHl9K/FIR4B31e3GgaA/o0litWhpxo9Ds3w9RWTMTB2/4qu8x7AEpthVA
a0BZGngiGZp8fxEVlQ33+Nuv+AziDQf44e0h1XvaHhBXaG2gFPtqm2EYpjswgu92
JHoIXhJaOrMPIgMVod2XOeXhZYCH71lo5txG1jLeHu3/D3RPfLVnIiHnQqF/TfGP
F/HO7B0nz0lDo1OfR9lw
=9upD
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Nov_2012_14_46_01_+1100_DNkW4WIlpo+28ze3--
