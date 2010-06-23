Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0FWAuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 20:50:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34762 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0FWAuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 20:50:22 -0400
Date: Wed, 23 Jun 2010 10:50:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (tip tree
 related)
Message-Id: <20100623105011.d4df34ba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jun_2010_10_50_11_+1000_oq/qAvmBhzKtsVkS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jun_2010_10_50_11_+1000_oq/qAvmBhzKtsVkS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the  tree, today's linux-next build (i386 allmodconfig)
failed like this:

  VDSO    arch/x86/vdso/vdso32-int80.so.dbg
/scratch/kisskb/src/arch/x86/vdso/checkundef.sh: line 4: ccache /opt/crosst=
ool/gcc-4.4.3-nolibc/i386-linux/bin/i386-linux-nm: No such file or directory
  VDSO    arch/x86/vdso/vdso32-sysenter.so.dbg
/scratch/kisskb/src/arch/x86/vdso/checkundef.sh: line 4: ccache /opt/crosst=
ool/gcc-4.4.3-nolibc/i386-linux/bin/i386-linux-nm: No such file or directory

Caused by commit 05d0b0889ca9d033a960542af7f8a13b3ad4f630 ("x86, vdso:
Error out if the vdso contains external references") interacting with a
cross build that also uses ccache.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jun_2010_10_50_11_+1000_oq/qAvmBhzKtsVkS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwhWkMACgkQjjKRsyhoI8xQ8wCeMVGkf2Ir4xtq0diXDxcrj1Cl
bf8Anjzm+rl2jvCPBuNm3t2qul00QGGH
=MwON
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jun_2010_10_50_11_+1000_oq/qAvmBhzKtsVkS--
