Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1JQQ7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:59:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1JQQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:59:48 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Vwe66Kt8Ke0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=aNNU65ThZqzZXrWP_2YA:9 a=7d3-GLmZUPPbm9-GGc4A:7 a=QEXdDO2ut3YA:10 a=E_1PHL7GFgMyInSkTB0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017160455.498567257@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 12:04:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/17][RFC] ktest updates for v3.2
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is getting close to the merge window. I want to post the
patches I will be pushing to Linus. I know most people don't even
use this, but I figured I would show what's changed since the last
release.

This is also the code base I will be using for my tutorial at=20
LinuxCon EU.

-- Steve



Andrew Jones (3):
      ktest: Create outputdir if it does not exist
      ktest: Only need to save .config when doing mrproper
      ktest: Include monitor in reboot code

Steven Rostedt (14):
      ktest: Add TEST_TYPE install option
      ktest: Fail when grub menu not found
      ktest: Add NO_INSTALL option to not install for a test
      ktest: Add option REBOOT_SUCCESS_LINE to stop waiting after a reboot
      ktest: Do not reboot on config or build issues
      ktest: Add IF and ELSE to config sections
      ktest: Let IF keyword take comparisons
      ktest: Add INCLUDE keyword to include other config files
      ktest: Consolidate TEST_TYPE and DEFAULT code
      ktest: Add OVERRIDE keyword to DEFAULTS section
      ktest: Add DEFINED keyword for IF statements
      ktest: Sort make_min_config configs by dependecies
      ktest: Fix parsing of config section lines
      ktest: Add processing of complex conditionals

----
 tools/testing/ktest/ktest.pl    |  494 +++++++++++++++++++++++++++++++----=
----
 tools/testing/ktest/sample.conf |  146 +++++++++++-
 2 files changed, 537 insertions(+), 103 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnF75AAoJEIy3vGnGbaoA1q4P/RQ5+IIMRYrvql2AMigobU+o
TTZGfb5jSUhQ61ygDXV5FoAVtY/3YbMd4FnDITW9LLGU/sD0mZSscUvQqQ3FPzCw
Eq4Xv3Y8n2bQsAjEliW4aSusrODem17knNKq5CgOFFh0hM6C/hZsvmuATSMLM2H1
6N3vXVMETbd+s0KbDqgidCop3Ut3/7O2WuZ4LNELMef7AGUEWsdmuDDub7d/IJev
OOFkTlvXaBvbfnWjDxwxw/xXdEUbN1H+o/1Q+x2KaZj0I4nvCRTUS8Ujh0RMhphI
rJO9Hv61H6P+3ttC92fXK2gKk21Zic78K/RCdJUvvuAPVOF9z34YMtz6yuFNQi5Q
CEl2I3YE/ma6wwmaepkDOftZ0rxPu95n5uXTuyEM/U+zATZLa1xm/U1JdHVKZtnt
9F0OKKrxnEprl+l6H0uKGgy500jCUMopkv6xonnBwhGo8ExQyd548tui+W00CV9H
aRoWPE6kvxJovIjwUCF3gNzFHMJ3eOo0BHKGDlnkZanxh399+9qftc1DML5ikFVe
usGJ60zKp4cDDiKUplhyeNFA74r55JRjtO1HiTV+rsFOUZgs3OT6l4obdunCTZng
b4FKd3b21f/M6xKbBXw1ApkP3ADq+sH1tTAl6jS8wj2Qf5W682nHPUuG4Tk77Gr8
XK/B10vbbkFUd5VBr7I8
=Uyhq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
