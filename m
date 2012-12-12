Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2LLWPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:15:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2LLWPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:15:44 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=oaqKGHf0UX8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=98sBLIZLoo0A:10 a=VwQbUJbxAAAA:8 a=sGyIs58Mxn7LyFXLAVkA:9 a=QEXdDO2ut3YA:10 a=rSP24lmfCNphnO0BzOQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212221437.245229327@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 17:14:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5] [GIT PULL] ktest: fixes and updated for new boot loaders
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Please pull the latest ktest-v3.8 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.8

Head SHA1: a7c85ac16cf29aa0fec5fef2fe26bb09a9e3ee19


Steven Rostedt (5):
      ktest: Add support for grub2
      ktest: Sync before reboot
      ktest: Add native support for syslinux boot loader
      ktest: Fix breakage from change of oldnoconfig to olddefconfig
      ktest: Test if target machine is up before install

----
 tools/testing/ktest/ktest.pl    |  120 +++++++++++++++++++++++++++++++++++=
++--
 tools/testing/ktest/sample.conf |   46 ++++++++++++++-
 2 files changed, 158 insertions(+), 8 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQyQIKAAoJEOdOSU1xswtMLuYH/imIQsn283XWlnSdrILDLuNt
lrcwcs3K0BfHmC5aGL7vdv8887x3i2Tf1k552MwhX8ettrgHeGk2Q4SZs8KW4lD8
uljjyZ/LJZ5BBvIqfzNBgRsysQt9+dxN44/l7ybX+IxCZeN2DMMhg5SV7OSxLrLl
h1UTufck4xc1gEP4/LZvwvfhu76tuuDx98LoFz8gGodw65q8xVDGDMGH4dmYtFCt
kChBGC17enY2xytoSFmYzJT2kxEgBweTtCWd0bUw4TduVfiBFFgL61TwdmF1kAhC
wqKHPykzAxeYaDXx8daUVzCZM8IszrstOEYfk537i+6U2HTK4PH/USyR3rzbimA=
=aNV5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
