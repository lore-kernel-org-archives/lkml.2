Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0JVDDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:03:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51178 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab0JVDDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:03:46 -0400
Date: Fri, 22 Oct 2010 14:03:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gianluca Guida <gianluca.guida@citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the xen tree with the tip tree
Message-Id: <20101022140335.c4a3a48f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Oct_2010_14_03_35_+1100_P2b_wdij5HjiYeCF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Oct_2010_14_03_35_+1100_P2b_wdij5HjiYeCF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got a conflict in
arch/x86/mm/init_32.c between commit
1d931264af0f10649b35afa8fbd2e169da51ac08 ("x86-32, memblock: Make
add_highpages honor early reserved ranges") from the tip tree and commit
07147a06ac3b1b028124ea00ba44e69eb8ea7685 ("x86/32: honor reservations of
high memory") from the xen tree.

I have no idea how to fix this up, sorry, so I have used the xen tree
from next-20101021 for today.

There were also conflicts in:
	arch/x86/xen/mmu.c
	include/linux/early_res.h
	kernel/early_res.c

These last two were deleted in the tip tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Oct_2010_14_03_35_+1100_P2b_wdij5HjiYeCF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMwP8HAAoJEDMEi1NhKgbsaEEIAJXWPpVTAAffqsezu9MmSoYT
4AsozAJPT6zQwna9uQ98vEOivlcTrbOHCmb6zXoKXFA8oohOc6AZYSvwls6Q+RCD
x6WN3t+F2VYhrJLvtgUNGT1VkxTbt5Wj9NqsT+ncbCIII3A8eqNp7USkbWRigLCW
RxEhiIuzZFVxlYTL1Hzk7bL37ieBZRHHiPOYDJGLFBJznMCwEsP9TR3Jb+CXtpuN
1I0pBdSTdXermDDpDxbkl0jOizO4CS5S+QUcSJdT6N6RHCFvPElsxokBD9oH8Hh+
edtW4UNZl395YqZWidlbvag5bxc79AVNI/8EY/a7BptpRo8BLM/LPgdf3UhfPdE=
=8HgW
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Oct_2010_14_03_35_+1100_P2b_wdij5HjiYeCF--
