Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1CJAxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:53:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52760 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1CJAxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:53:37 -0500
Date: Thu, 10 Mar 2011 11:53:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the nfsd tree
Message-Id: <20110310115331.10a95d57.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Mar_2011_11_53_31_+1100_Jdn1VghIVlGBtS2O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Mar_2011_11_53_31_+1100_Jdn1VghIVlGBtS2O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bruce,

After merging the nfsd tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

net/sunrpc/svcauth_unix.c: In function 'unix_domain_find':
net/sunrpc/svcauth_unix.c:58: warning: passing argument 1 of 'svcauth_unix_=
domain_release' from incompatible pointer type
net/sunrpc/svcauth_unix.c:41: note: expected 'struct auth_domain *' but arg=
ument is of type 'struct unix_domain *'

Introduced by commit 8b3e07ac908d ("svcrpc: fix rare race on unix_domain
creation").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Mar_2011_11_53_31_+1100_Jdn1VghIVlGBtS2O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNeCELAAoJEDMEi1NhKgbs9SAH/jOFrd38fx9xYZDdmj9wZl6r
d9AMmwdxg3eAdyL0VgukfTfNna+Lv36rBQtL+qv53KkbS26+L9yB7h/fQRzy37VJ
Zls5nnNkgDL3BNODo9023B2za3vHcJVzvwoOIobdzNgS0rRIfYn35zvOLE9Rehoc
kHwPOz3kSi64Zj7DTu75/d2sSoVKtwb93BrVU/E26dPEnuSOsT7pzJksRSIYhmSI
TUqOIzrNUPHAR1FfQsjqMlmftCw5RG/FdJM2fEIYP/jyofel3ugiQn+4q5fBoZmK
lbLJgURujzo1CMptEAlO9DWDGmQNADMkIcpEPN8Pep58RKtGjNt31gvHy03wfZM=
=SAyX
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Mar_2011_11_53_31_+1100_Jdn1VghIVlGBtS2O--
