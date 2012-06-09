Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924Ab2FICEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:04:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761458Ab2FICEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:04:20 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=hHX9Kg1jsSUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=Ysl_TwCqrwvU0gLRZ3MA:9 a=QEXdDO2ut3YA:10 a=3clxoborQ9FyOYDu80cA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120609020257.248773533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 22:02:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/3 v2] [GIT PULL][3.6] x86: cr2 and cmpxchg issues of NMI
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This is the version 2 with the updates suggested by H. Peter Anvin.

Please pull the latest tip/x86/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/core-2

Head SHA1: 70fb74a5420f9caa3e001d65004e4b669124283e


Steven Rostedt (3):
      x86: Save cr2 in NMI in case NMIs take a page fault
      x86: Remove cmpxchg from i386 NMI nesting code
      x86: Save cr2 in NMI in case NMIs take a page fault (for i386)

----
 arch/x86/kernel/entry_64.S |   20 +++++++++++++++++++
 arch/x86/kernel/nmi.c      |   47 +++++++++++++++++++++++++++++++---------=
----
 2 files changed, 53 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0q8aAAoJEIy3vGnGbaoADOUP/jiT3y1dPS+ce1KUH0hRbKQ/
n1dHQTsjWfI7txmNxf1tf8PRYiLEPPnDivBF/hvxva2dz07Y/op4jBwzX3ZUJLnO
yI5OA8b+tTE1gPP5ZKT5oTstuxd3nSmJKlB+HPvhFk71nCpdE3QwtK1aUKje4ifC
PFR2TL3wDgvXOdt0hj1keATVC+ZoxP4PQL9yTBUaMTw7sBaxNPQbFzZtbudfAhmX
8CUj1DeWj/8doKicD0w5J4qap5ZtNvuLDbKYdgIhEeAZ78T6sSXcCiWUPCWUY1cv
4v3BeqbBoGbp2CWm4mdDXgOs4z+h/ZF61+XkkLiiYEWy8rMKzzWnPOxMfm5tlU+a
ANDYg/pTgNJ+UzO7YC2u+sIPTsCrFPxyzMB7z8wYWCrjn0pdjVybO8en5usNodfu
V8o0GTc3nFvEA+czSgfGl93B5INeNNPoIUWcDPXGH6aoUrCN3nMC2OiQWFS8Ki7Q
K9dr8mF/JtSZB+hTITaJs1HJQD3sTDj1XYPGdJ6iwaMD//LPbqCHJSMiadSb5Gmp
5Z7/pneZmGN0cVeGxDuj/2+9AaOciSK/cObe7SHlocKdci8ro7BjLb12SJ3O299T
scun1gfHVyOImqpIoks3h65CVHuBNIvVxRBFjIaFR9EXcZoa1INi54T82O9xOyCb
R9g85uVofccwhruk3cu1
=E+ja
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
