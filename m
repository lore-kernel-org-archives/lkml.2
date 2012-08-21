Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2HUCLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 22:11:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44744 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2HUCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 22:11:36 -0400
Date: Tue, 21 Aug 2012 12:11:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Michael Cree <mcree@orcon.net.nz>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20120821121126.f26a74eeeb19093b6d33d7ee@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_Aug_2012_12_11_26_+1000_zRev/kkQXRj=fQJt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Aug_2012_12_11_26_+1000_zRev/kkQXRj=fQJt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/alpha/Kconfig between commit f2db633d301b ("alpha: Use new generic
strncpy_from_user() and strnlen_user()") from Linus' tree and commit
d673c23ca730 ("Make most arch asm/module.h files use
asm-generic/module.h") from the rr tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/alpha/Kconfig
index 9944ded,e73a1a7..0000000
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@@ -18,8 -18,8 +18,10 @@@ config ALPH
  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
  	select GENERIC_SMP_IDLE_THREAD
  	select GENERIC_CMOS_UPDATE
 +	select GENERIC_STRNCPY_FROM_USER
 +	select GENERIC_STRNLEN_USER
+ 	select HAVE_MOD_ARCH_SPECIFIC
+ 	select MODULES_USE_ELF_RELA
  	help
  	  The Alpha is a 64-bit general-purpose processor designed and
  	  marketed by the Digital Equipment Corporation of blessed memory,

--Signature=_Tue__21_Aug_2012_12_11_26_+1000_zRev/kkQXRj=fQJt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQMu5OAAoJEECxmPOUX5FEXIUP/Ry8Y43w74Ww89HcHAah6ar+
5yQh60cC7xCb/H5gncHUYr+bYP/Mx5p92DHQF15KJtiZ4X/UKewm2a1iPJLbxvhP
F3+ZyAIA9eCh98wDv2LM7iO0glftdOehslydRy/Bq4y6kPOnIEKUBm8JYHdTgwID
7gMXkQCYbh8F0zlC5p5qYXFb+TFCghYr1F1mlF7qfTUb3GSVcS1u78YmuZUwlDzu
ac5W5rPivzv8rXwez7i5/oGQ73oKTM71Jh7CzX9e/+CQLN3bD5eV8EUK2M8ddBVo
tfRVwPm4YjhgOFDai7MHHTxBet07L+L15zodPv5v5ceFDEXAwjlmcfg8bmiyDWnk
HguHO2kFx/7uYJy5lh9q3y6otDojZ6D5IxnurvtBsPcwBv8zKYWvGwQD/LFK8gm1
W0bQE4lBNUH1zmSIgd7ONS/pTuBvKNKE7GJbVL35SMOL56skySg11glLxoudf3rP
VIXFJpF17g6pXPYTsVW+pE9gRHyFBVAXXPxU2Js9nPsKM+mT+wr3nE5P9XQmItsG
Ko6JokiGXlRYvjexKI4BkgxerTDnh7p0CGcUdShGo1aqCBLCuNfz3RIEi7IJebp8
2wA4AzVkIOAcrpWCnJGTmPOMvthdbeIfYRWMF1dTvIv2ry59yc/zeoZmIsX1A+r7
uVSknJVOl9ynH/RdG3LF
=PfZi
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Aug_2012_12_11_26_+1000_zRev/kkQXRj=fQJt--
