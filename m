Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2HWDWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:22:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51868 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2HWDWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:22:03 -0400
Date: Thu, 23 Aug 2012 13:21:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the kvm tree
Message-Id: <20120823132154.e823d579e1f2c82b0e283a5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_Aug_2012_13_21_54_+1000_CvmtnfgW4=FwcpY5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Aug_2012_13_21_54_+1000_CvmtnfgW4=FwcpY5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kvm/built-in.o: In function `.kvmppc_h_enter':
(.text+0x2494): undefined reference to `.gfn_to_hva_memslot'

Presumably caused by commit 4d8b81abc47b ("KVM: introduce readonly
memslot").

I have used the kvm tree from next-20120822 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__23_Aug_2012_13_21_54_+1000_CvmtnfgW4=FwcpY5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNaHSAAoJEECxmPOUX5FEQw0P/1M/kah/6hmN2IKeB2ffnoUj
+znMXWEGTLj/EhcmpG0Ga22R3nh0dKxXn3KjuYxBALDpam2sMvrC+5bc1noso5bx
sTIdPkh8gcPT8psyFlXoEQMaKiqHiXmZe7vDw4qFD3MW7f3v0HyPLaLFH2w9djG0
BWDBzKm4ez0xzggJJkBGH461Gd/QdtWrQjfyFEbQlK8u+lwpy8R2gsJ2aTJ0ix+y
2/qX3RhB/pTtoT7FW109CgegbCB0kdLCfhYiILiT9FLPDc52Be7BgTEc6U4sz0HK
rd6GjeIBFNRZJpPdWMP1YhSnOzumqHgdoNXq7IkF3Wbe5uHKlsYbuVJTB+0x8ONy
dUdbnG/C8B04RP8vtHTcNFAyEsPN1WW9sMlOVWzBtgxvD29LOFRuTjcKckiNg7vb
Pw6YBHrlzaLbGSFzuGbYELPf7AQg4rwqhsCEGPVKiWxNMTA+TR6KXKa9ENSiJFvv
F6RlMAjn/9HyVtCf+IZGmE50B2xHVIlnBMQyuw8fggAydGDyVk0CHkj7o4Hf7zxp
54tZi56I7aPXc5ZyoGjOPkt8bds/SHti3CXzArqmj9Say5u1O0E8M5cSAujvj50X
pQx6QGs2eBG5Yrt9ViHMvndfBD9IGdW4j0b0htW2oc2ijDbk1Ba6/wXJxs0rqcj+
6pesXB2L0piuSDLYayHX
=R6RP
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Aug_2012_13_21_54_+1000_CvmtnfgW4=FwcpY5--
