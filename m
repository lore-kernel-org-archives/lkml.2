Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab2AEDsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab2AEDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:22 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=ic6vJ_jGpMkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=v4j6oP9XcEL-sjnmyjUA:9 a=LuBryxtFqUdvMShSxhkA:7 a=QEXdDO2ut3YA:10 a=azmNMt-tzr66Mvj4ErkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034755.793909214@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:47:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 00/20] ktest: new and fancy updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-linus

Head SHA1: be405f95f0a090d1dfc26a5bb4d781c00f34479c


Rabin Vincent (3):
      ktest: Check parent options for iterated tests
      ktest: Save test output
      ktest: Allow success logs to be stored

Steven Rostedt (17):
      ktest: Add default for ssh-user, build-target and target-image
      ktest: When creating new config, allow the use of ${THIS_DIR}
      ktest: Allow bisect test to restart where it left off
      ktest: Ask for type of test when creating a new config
      ktest: Do not ask for some options if the only test is build
      ktest: When creating a new config, ask for BUILD_OPTIONS
      ktest: Only ask options needed for install
      ktest: Evaluate $KERNEL_VERSION in both install and post install
      ktest: Evaluate options before processing them
      ktest: Allow overriding bisect test results
      ktest: Add options SWITCH_TO_GOOD and SWITCH_TO_TEST
      ktest: Change initialization of defaults hash to perl format
      ktest: Have all values be set by defaults
      ktest: Detect typos in option names
      ktest: Fix compare script to test if options are not documented
      ktest: Still do reboot even for REBOOT_TYPE =3D script
      ktest: Add INGORE_ERRORS to ignore warnings in boot up

----
 tools/testing/ktest/compare-ktest-sample.pl |    4 +-
 tools/testing/ktest/ktest.pl                |  698 +++++++++++++++++++----=
----
 tools/testing/ktest/sample.conf             |   87 ++++-
 3 files changed, 597 insertions(+), 192 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2BAAoJEIy3vGnGbaoAm0UQAO0Z2t3HgfCwnkNCDDF3K/Ug
1pYd9F/CNtmsjRCueyYaumW3O24GWfDpKWOa591FKSPOXiyXBzjk0KE3Gu0zArZy
wCq7+mKkxQznY1mM16fugTvYsTIN3Ml7xdgnoVhtjY8IV6YcD67rFYC7A3GKzQKi
N9uC6QU/4zio0YpC8i6wqxK0Unsphreg3/8oFZLtH1kkyXPnskf0tHiyj9SUpERL
EjDZtpBpzXqIcP2SfDmd8fSbwpXQiWEFFqPsaz7VupxRLNzLYO9DRACbi7tM8DKf
XLwsH9I1KK7DQA2p4l4PLL0EbHPsy8ZNsKkNFNhEAc1pIwIW2Gyy1uxoX60y6xuJ
c8rgHKX8+Tz/CPnu/KOSpZ86cWveGjvTabnIBB7xF749LE3weZF3zgLhSXS9mpgE
2zc0EW/4MgFr3dtx7DEEQL9hfNbmmSzWuOUl9r7s5I49/vjE0Pgni4TUFgUlMIus
llQTJnYNi7TSSSbxAA2Xq6VWTRboP+vDbYF3DZLqI9ASwDfhbsky0dXlkQehiEmD
KmReAaukWH751Xl8z1V0F/nnHLu8gf4XhKDHRWED2hp89Ig3rsj9KO7oi0AfyHVt
oWWuJ9/jp3CqhMV+YFIl5Hz1b7oykdw3b1MkxVRUtIcFU+vgG1N9dMB/dtfl+HGv
jDCAriNu3W0Z1lqyE0m0
=c7Um
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
