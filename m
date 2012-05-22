Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2EVIVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:21:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33157 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2EVIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:20:16 -0400
Date: Tue, 22 May 2012 18:20:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120522182010.f93a38e575ed34e88de5b787@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_18_20_10_+1000_QVze=VO6dbtv85c7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_18_20_10_+1000_QVze=VO6dbtv85c7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

arch/sparc/kernel/time_32.c: In function 'timer_interrupt':
arch/sparc/kernel/time_32.c:105:3: error: invalid use of undefined type 'st=
ruct clock_event_device'
arch/sparc/kernel/time_32.c: At top level:
arch/sparc/kernel/time_32.c:111:17: error: 'enum clock_event_mode' declared=
 inside parameter list [-Werror]
arch/sparc/kernel/time_32.c:111:17: error: its scope is only this definitio=
n or declaration, which is probably not what you want [-Werror]
arch/sparc/kernel/time_32.c:110:53: error: parameter 1 ('mode') has incompl=
ete type
arch/sparc/kernel/time_32.c:110:13: error: function declaration isn't a pro=
totype [-Werror=3Dstrict-prototypes]
arch/sparc/kernel/time_32.c: In function 'timer_ce_set_mode':
arch/sparc/kernel/time_32.c:114:8: error: 'CLOCK_EVT_MODE_PERIODIC' undecla=
red (first use in this function)
arch/sparc/kernel/time_32.c:114:8: note: each undeclared identifier is repo=
rted only once for each function it appears in
arch/sparc/kernel/time_32.c:115:8: error: 'CLOCK_EVT_MODE_RESUME' undeclare=
d (first use in this function)
arch/sparc/kernel/time_32.c:118:8: error: 'CLOCK_EVT_MODE_SHUTDOWN' undecla=
red (first use in this function)
arch/sparc/kernel/time_32.c: In function 'setup_timer_ce':
arch/sparc/kernel/time_32.c:133:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:134:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:135:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:135:17: error: 'CLOCK_EVT_FEAT_PERIODIC' undecl=
ared (first use in this function)
arch/sparc/kernel/time_32.c:136:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:137:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:138:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:139:4: error: dereferencing pointer to incomple=
te type
arch/sparc/kernel/time_32.c:139:2: error: implicit declaration of function =
'div_sc' [-Werror=3Dimplicit-function-declaration]
arch/sparc/kernel/time_32.c:140:26: error: dereferencing pointer to incompl=
ete type
arch/sparc/kernel/time_32.c:141:2: error: implicit declaration of function =
'clockevents_register_device' [-Werror=3Dimplicit-function-declaration]

I have no idea what caused this, I did not get this yesterday.  I have
left this build broken for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_18_20_10_+1000_QVze=VO6dbtv85c7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPu0w6AAoJEECxmPOUX5FEQcIP/2LqXcoQ455Y/1F4tWzrnIkD
C6/hW3hPbxqJyzn6EGVjFML5/4VjbgHVERO1Uk4EE5yVsTJnuEFl+fB4taYnUDEj
5WA7255MFLaYokBVzqZYMSkKQo7hCCWPqRVp3BGReckoxhScGFSF5yVom3xHXjC9
6ryU1jwF7Nti8Y8gPnUKHdq97oKtfYuJqwkv6PFGit/WLAZKGh7MYK6vFZDKEEp1
+4fu6GXFNJuSfHbSvDlj+z+qtKX9cMSw2pIOBLZd0sBFJ+/u/7s3jjQykIyvN0j8
GtA4MdEB5iXwxHTuqKN4uhRP4I91tMv3jtzBIpQ3MtCfMyoM3o8T4TB64fxyTgqL
NTUvhs+2s2kByOypCvzzXUza4vaChOhbEpXtdVro0iNUvDbKi+vOnxsL4Nc/1Q2a
YgeQURXYXcDzr+YDzMcR3Yb7txbVo5SLKjm/yZrRx3ChlBC19seTKuMiziF2ROja
5FJAsK6MN0G3Mq83t3oH7H2JHOD49fKjQPPHJIBQwO+/bnYewxRcS31MB2Ha6q2G
2cj2aY/nezjBM6gWOOOt+9GM4RIwN+Fx/vvcUOiTbdyDr//C8Bxr2fy9fmLLaOC0
WuG0hqtjh50EaGEptgWIm1nFrGfTrmWv2uNr+Z4kYiKhF6y/h8UUwN3z4yjOUC94
o6ENkBnldQR2fmE0DIde
=HIpd
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_18_20_10_+1000_QVze=VO6dbtv85c7--
