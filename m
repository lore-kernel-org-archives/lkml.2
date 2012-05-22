Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2EVMGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:06:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2EVMGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:06:31 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=gg-3lC_cERoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=4XPeABxATd8Ua5TJDF0A:9 a=QEXdDO2ut3YA:10 a=M4sxeXNQRb1kNb7f0LAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120522120531.460108326@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 22 May 2012 08:05:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/8] [GIT PULL] ktest: updates for v3.5
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Please pull the latest ktest-v3.5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.5

Head SHA1: af738c3e4870c304b8c8c69e11bc6517b5b52d10


Steven Rostedt (8):
      ktest: Fix kernelrevision with POST_BUILD
      ktest: Add MIN_CONFIG_TYPE to allow making a minum .config that has n=
etwork
      ktest: Add USE_OUTPUT_MIN_CONFIG to avoid prompt on make_min_config
      ktest: Add useful example configs
      ktest: Add kvm.conf example config
      ktest: Add an example config that does cross compiling of several arc=
hs
      ktest: Add the snowball.conf example config
      ktest: Add README to explain what is in the examples directory

----
 tools/testing/ktest/examples/README                |   32 +++
 tools/testing/ktest/examples/crosstests.conf       |  260 ++++++++++++++++=
++++
 tools/testing/ktest/examples/include/bisect.conf   |   90 +++++++
 tools/testing/ktest/examples/include/defaults.conf |  157 ++++++++++++
 .../testing/ktest/examples/include/min-config.conf |   60 +++++
 .../testing/ktest/examples/include/patchcheck.conf |   74 ++++++
 tools/testing/ktest/examples/include/tests.conf    |   74 ++++++
 tools/testing/ktest/examples/kvm.conf              |   88 +++++++
 tools/testing/ktest/examples/snowball.conf         |   53 ++++
 tools/testing/ktest/examples/test.conf             |   62 +++++
 tools/testing/ktest/ktest.pl                       |   36 ++-
 tools/testing/ktest/sample.conf                    |   16 ++
 12 files changed, 1001 insertions(+), 1 deletion(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu4FAAAoJEIy3vGnGbaoAG2gQAJ9DSqa3HnxzLIpe0bvlhSy9
unwy3P9/LxQh5m9iwcK0cpmjWq1Dopmb3BqdKSWHnd3acS+NOCwgShxFbj4Xuubk
JiQ0teWrtSc8S7uCQNubb9J8BfOYv3AP+i1Cac278OfGs/D4g1KBN2gjj6vfh8ht
ctFxv7B8Eocz+ZaUBDJeoXSLQLNi7w733y4ulhgHnC/5RXufAaRljGETj+Y92Kmf
8dK0lTVdhVsn5+TwKHQhvS9BI1Xi0A1P8M+j6b/wW/Jk1iHRj50xX0Jm14LhMM33
F1rx3/ZDU+xMd/0VBqyZbsnCXZ6gH7dFiBV53WXds7R1bUZTiafsw2qJaYPfGscm
QWr6aLpLdI+NNZ3e5koiBexbf1AWSGtG7JZj4Tm1wv6gT7UeUoX37s3UtkSKwq4N
PMPqmiITVKcRtRudbugBmEiToa6J+CQ/yxYcY2OMWw58UHxs5xopkfQIvuCXaCv2
yhy5ILAsx0DQ6mgwpdQgCsJPO3fg6NexVWSAGanS/xYcc4jTqQaJlISda5x0Mj6A
dD+PCcwz+zivZ1LcFVU9latoyKuBwJP08PO5AIXDCz2WsKf4K7fe6PcUW8StFEru
t1xgX3cvk8X18PwwTBx4EsNYxa3TbuHIU+2BTckG5AyZhmfTreGcKpTuLMwlfvPI
DWPenhD4bXLalz4A5T1D
=Xvhl
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
