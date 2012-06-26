Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2FZEgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:36:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41552 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2FZEgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:36:51 -0400
Date: Tue, 26 Jun 2012 14:36:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Fengguang Wu <wfg@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20120626143638.278cd26a1fe00b4161ba7691@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Jun_2012_14_36_38_+1000_q/f/f4qDINiOLVi4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jun_2012_14_36_38_+1000_q/f/f4qDINiOLVi4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/asm-generic/bug.h between commit 09682c1dd382 ("bug.h: Fix up
CONFIG_BUG=3Dn implicit function declarations") from Linus' tree and commit
7b37393f13d5 ("bug.h: Fix x86 !CONFIG_BUG build regression") from the tip
tree.

These are trying to do the same thing, so I used the version from Linus'
tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__26_Jun_2012_14_36_38_+1000_q/f/f4qDINiOLVi4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6TxWAAoJEECxmPOUX5FE5osP/2BcJZAUc/O3LQrdIvWYSN/h
UjS0hT9/o2g5c8KRF2xll6T+fsIwbuU0OfJ4OHe37VtTSUfbu0r8W8I74fSXdEgT
PYvmoM5rH85gJ3onZgKrkMn2Mq353rLxSPu2YinIjSPKBbT+lH3etrJrPWdRHqHF
fIP/js4c+jC9xQUn731n+/DakbOQWwsrwaXB7eRpTZVfR65p0xrXeatMgiyXTZ4e
AYEREmeEuwvkkLx6yaggYaYAh9CtItuYqdZeZMffGOrDbAU4WfcKYSfiyG+xfE5b
8NRia6Xkw+WzXtFHfLTIw1mKEwYlatclrVctw+JE1TjZEM/j+XIa3+DTiul4HBlA
yGSvZstysTQHTt9cskGSCIMIZVAU15o+lHQPgvKXhH2fHmiC+4qKIncF+bb3JIT4
WKTqv9862NPpd+Xzcd7nBRTDb0ebsog3xwVATPx8rt6YFxrgS9nAuwSM7QWzW56z
6onXgA1HYHZjE5rNyQ4BhOv8C7wArlxE7MuDher8wXJj9k/3PoPnd5n31Ff1PQtN
ZZzT/oMewC016GAjUTNnhSaRcUHQehKr2EjieyOBcFuaSfGhwrulo7L6FQRgNKO3
Q9yv3ieOdoU/GWcWZZYyls9HfUOn7DAjKoeZuhwQspGI1uUkk4x1phNRyWCuU+w0
f+AeeJrnME9KDgdGvGmg
=jEMC
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jun_2012_14_36_38_+1000_q/f/f4qDINiOLVi4--
