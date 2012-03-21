Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2CUQCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:02:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab2CUQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:02:45 -0400
X-Authority-Analysis: v=2.0 cv=UcbTuduN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=3gwJN__nrtYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=tD8aojfSl4uvPDGahv4A:9 a=QEXdDO2ut3YA:10 a=aD3IcDiqfzrDEDDdToIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120321160125.496052559@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 21 Mar 2012 12:01:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5] [GIT PULL] ktest for v3.4
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

(hopefully my signed tag scripts works this time)

Please pull the latest ktest-v3.4 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.4

Head SHA1: 5909e3e9c417e56ceb61a4733441766bf4be82cc


Steven Rostedt (5):
      ktest: Add INSTALL_MOD_STRIP=3D1 when installing modules
      ktest: Add warning when bugs are ignored
      ktest: Add SCP_TO_TARGET_INSTALL option
      ktest: Fix SWITCH_TO_GOOD to also reboot the machine
      ktest: Allow a test to override REBOOT_ON_SUCCESS

----
 tools/testing/ktest/ktest.pl    |   56 +++++++++++++++++++++++++++++++----=
---
 tools/testing/ktest/sample.conf |   14 +++++++--
 2 files changed, 56 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPafugAAoJEIy3vGnGbaoAxz4P/irIY1FAp4hL38YeusXEwRVu
Ud/s0t1xtt4gITL4KFNVv9qSnn8Tl64YnrH35/0ecEh4QzimW2BC2gWCoDTVbe/P
oTCWIrQtM/Xgp8ofEs6kKGN7XH/7JlsGUh10IJ7KCCC9L082scN4HTZ/QSSV+aND
S/VqIAc4/7ThbTdUBkKPHpDy7VMHeOcJh+5U5QpdQDRwXzPZF0ddGKvoCAC7vGET
Oa+pgnUM59R9aH73USWS9QBjuPiXS4YgXLQIOxXR45sHOyRRobY6OqrzmH5QfaBK
WRn3vPZD0p77/+GyCIvwVdFfTzwNwdANVplyhr7gvNBJQOAEWFGxE5WTZQlToEiE
QzmdrBWoMnEQws2D0P4ezFGtOFBiCGd68s4LhlVLuSIVWSNj/qIUVeeQy94JaVco
Y/6Qo4LB76j8It5EG/7/k/HMVC0x5C4L8LfRC1E9qS0NjwsiqF1VpYsBNrQ5ZC69
/Sif8HIlYGHc4BeB5YlZHAkNAne2H32pOYn/bNZ7oEa6czRruCIVIT3khTDf7inM
VSaZFY6e7dfNVuWw/nZPDtE9G813sYMb/ExqfPJ62G/8pQqjvPzy7Nnxm+V+cEtz
cLMhXTlYN3XdhlS+jTsVRMDE3mwtgGsXla1epliUtkgeKqUHzljrgxNXFADqarHv
Kq4ytrQthCIJzLeUT6Co
=icKq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
