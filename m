Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab2EPHY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:24:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59821 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab2EPHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:24:25 -0400
Date: Wed, 16 May 2012 17:24:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Subject: linux-next: build failure after merge of the kvm-ppc tree
Message-Id: <20120516172416.781859dbc2febbda67407576@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_17_24_16_+1000_LwGDrHSMHnnsZa8F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_17_24_16_+1000_LwGDrHSMHnnsZa8F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

After merging the kvm-ppc tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: "kvm_hpt_order" [arch/powerpc/kvm/kvm.ko] undefined!

Caused by commit ec26346431bb ("KVM: PPC: Book3S HV: Make the guest hash
table size configurable").

I have used the kvm-ppc tree from next-20120514 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_17_24_16_+1000_LwGDrHSMHnnsZa8F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs1YgAAoJEECxmPOUX5FEG8cP/Rp0yPxt+3DD53/q7+5Hd8Sg
dwsNxhSIDbos4mCfytozEwHPj7ayhnehUbiygdKj0UWM5dwxVCHHVT959WecXNGU
9o+b0tWoQRzB9n7+OXxUmDNuCUEV2t1Y02L3UXUmwLh86wJuYe8Udp/0VsphhEqh
4+kxnLGK4MosfFU/Ci98hjVDcacWx/msAy5oV1n89eXiOwZZFN3D+4XAfynObOiS
MZrasY+AXvU65oxNMYN6H4y4NLCTTKMXd2n2UAYy3YTfIXCG9Pup27pnLruUixfR
c05bAh2R5lO1oe7/ryo32EqP75ALNX1fwXC0NHVUoHxxXFXaiJXMtdjeYwz6cO5P
1F6WkMa+qV6QnVhXgSXsuQJzfotHjm29vN8pqdNMSEWP6ZjNpBKL+/KljxHN7g47
Du+hHm7l3g7ix81Q7BCoeNoO4b5u/xjjulXLqzaeaZf+YDOnHMHEirY70WuZmTXp
PsUWUVFuAwBr32aUk6RSe1op+Rwsjl7rVvJkbpzwdCgCbrurODFsNodv5tWedtu3
FS49U/GbZdENhApsv0JKBOJe4BZIAsp8/+dbxPwKcy6pw4XwAyTVOnB8335A9Mb7
UnZKASPkNfzZ1YwN5MpICRrOLPZD4FWi/MLwbvY6an3mpr24cSjWGX0kNY3TTGm5
aqMM/6oJmEAdqi9Hvxq8
=QlT0
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_17_24_16_+1000_LwGDrHSMHnnsZa8F--
