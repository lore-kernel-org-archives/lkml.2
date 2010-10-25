Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0JYCwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:52:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35764 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab0JYCwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:52:45 -0400
Date: Mon, 25 Oct 2010 13:52:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20101025135237.337b8321.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_13_52_37_+1100_DiI32BW_C7q5w.P_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_13_52_37_+1100_DiI32BW_C7q5w.P_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

In building Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

In file included from arch/powerpc/platforms/iseries/exception.S:32:
arch/powerpc/include/asm/ptrace.h:60:1: warning: "STACK_FRAME_OVERHEAD" red=
efined
In file included from arch/powerpc/include/asm/asm-offsets.h:1,
                 from arch/powerpc/platforms/iseries/exception.S:30:
include/generated/asm-offsets.h:87:1: warning: this is the location of the =
previous definition

Caused by commit 3234282f33b29d349bcada40204fc7c8fda7fe72 ("x86, asm: Fix
CFI macro invocations to deal with shortcomings in gas").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_13_52_37_+1100_DiI32BW_C7q5w.P_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxPD1AAoJEDMEi1NhKgbsMaMIAIBP/fpthvcZe570SoG0hfmB
3I47vAIo68hMEW6iKbtTImQSznwYV4XCHLW/Ua/t2JWT8e9XhQb6R8ZZ+HNHnThV
myi8wV3Hky6gy05pOe+LTi7w3eG75NX/6FfgXhS4i4xuMGJDYmEw9qAcLJ9ALolH
12JjMs03sHma6mNhj5BIK222pxmnSdu/Evnpi746GbJicD3s5XApz25nIyew+8xS
gjYXSzApijHjshZjnji50Tf8Mpy7c7x7Db5NfrPNwnOz539gUW6Vx3IVLyn+D282
U+o0fPTuLs/D6M2QsF3iCw211wDWX2kUThZWTSI8uLp/g6H03YDefn8r9ClVuO0=
=SCn+
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_13_52_37_+1100_DiI32BW_C7q5w.P_--
