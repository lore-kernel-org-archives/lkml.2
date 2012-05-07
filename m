Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2EGAJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:09:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38196 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2EGAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:09:08 -0400
Date: Mon, 7 May 2012 10:08:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20120507100856.a54d45c94b395de81dd2b207@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_10_08_56_+1000_kgpDBL=6JPuDMGrD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_10_08_56_+1000_kgpDBL=6JPuDMGrD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

While building your tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "set_personality_ia32" [arch/x86/ia32/ia32_aout.ko] undefined!

Caused by commit ce7e5d2d19bc ("x86: fix broken TASK_SIZE for ia32_aout").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_10_08_56_+1000_kgpDBL=6JPuDMGrD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpxKYAAoJEECxmPOUX5FETz0P/j+LXU0ML+Oa9xJiX3MbDbHW
auXRW8DMHJw+eBUDebUt06Hb0lGbfBkRk8o72dHMEOWJ/zbzJqjMkdqR+I9G/VPI
KveFYi7Ii0UQZRT+O9UewpP6bWz2nCg8+mk0YnxxeWlAnL9Kb713Q77F6I53u/vs
ePfnatVOrkA4MSbubg03PiJ+x2XkJVYkvDNFjM3nI2kWXjWB3bfRUCrMqW10GlcK
dGcmxSemes5SHonAQXcxJ8MgbAshfAoD6SbJ9Qpg21yqLGE6DPsSNN4RlgO+OxpT
5qt09DO9Nl0QWAiZ+60HSEHZuHmpjufqa5OSuB0umqHNqQSSlarih0s2uYknQQMU
BubWnwt3kpFe1KUMgf1KQ9sNQT9w29Uy6HthSSzbNGhz7hRNSDizdOy8Fjnii/tj
L17rJt1teRwj4qMbtvwGL0vYrzDNki+7Io/3f2q0J0Y9z3bS6mcitboxKqcwc0Ob
Lg5ZlKPflcz84Q9I1kvayRBB/GeK5sXPBv1xpNZRIb2Qpd847NrvoP62vHR6fzTF
e8XnjjKWGUYf+ppJXV3ovqK/Dum6eBR5riFxtRijXCgGyAUMYtTOmsu5AiBOMruY
MGUObtrRmo7HtdgFxZjvhkWcL2oo7NQOfSEoFedADpQJFWFLIJHLLD4xwutXyARz
+ISWmlkFz5n8uOpMxXq4
=2Q69
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_10_08_56_+1000_kgpDBL=6JPuDMGrD--
