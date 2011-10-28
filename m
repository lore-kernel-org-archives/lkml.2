Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1J1LUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:20:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1J1LUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:20:04 -0400
X-Authority-Analysis: v=1.1 cv=QqHiGEe6yGvmA2Hj/+B5Qdh2oWFRI3gWtdRZxD5t9t4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=1xFA9SD5vXsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=zih8Ozs0-uc-Vj75HMQA:9 a=NuUGB0bDSLzwfZBdle8A:7 a=QEXdDO2ut3YA:10 a=QlxBUpCubfPZkGjTCGoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111028111558.173726794@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 Oct 2011 07:15:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/21] [GIT PULL] ktest: lots of nice new features
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Linus,

This is the udates I have done since the last merge window. Some included f=
ixes
I needed to present my tutorial at LinuxCon. My tutorial was based on the f=
eature
set added by this patch pull.

Please pull the following patch set:

HEAD SHA1: 815e2bd7d609da9c7615ea28a3990064a394312f

-- Steve



The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git

    branch: for-linus


Andrew Jones (3):
      ktest: Create outputdir if it does not exist
      ktest: Only need to save .config when doing mrproper
      ktest: Include monitor in reboot code

Steven Rostedt (18):
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
      ktest: Do not opencode reboot in grub setting
      ktest: Add another monitor flush before installing kernel
      ktest: Add variable ${PWD}
      ktest: Evaluate variables entered on the command line

----
 tools/testing/ktest/ktest.pl    |  515 +++++++++++++++++++++++++++++++----=
----
 tools/testing/ktest/sample.conf |  146 +++++++++++-
 2 files changed, 553 insertions(+), 108 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOqo/cAAoJEIy3vGnGbaoAyDQQAL+PNWALeP2j3XiWuzF3ekrb
N6gkh1OuJCP8FHO1Kw+IzaU7639jdRd6Y8EcLZi2/NdvZ4P93B7GFVCAMXyNRzDz
mTa65eXxhKgDEFTP/UOWqL2r+bVtriZc/lsOCCSfWTz/Abwi3PgtiRHROC8f0LRD
v2vlCacKHnaaYGk7ohXA4p6/b1oAoGOhdrFxwHciH8vNNn2Oz+cMemctV4m1BGji
eRmtQNdxI/WPwnWjcSt7Rk33Ubh1LOIc7gGks2nSH5xp+mwKIsObajCBfR12xpVD
Ol1acyevxLZeeRCRW86+w4BeaGGiwqZpfvxIL6BaSJJgtx5ZV33vqHPnyuG0yJe2
UXafrwMoYYdyM3eyiZoNWGyX573wIJWKiiDG7VxkbPgfFuhQpYP92HsIR3UBItM+
2Vsr1Iob6RyNIRalxR2NZa89VaSXmzauvGAoarMjfaSLAmMMHdrqMf6XGPd71wDS
EWrHsqS5CEkdXdCbBMc6g9OrJgk735SrJHjvz70MAJanryaboUDXF9h0ZAirz2Z/
PfRJ0A/J4NvTvqficchcyVAlAOdW9RN7/tPFRoj4ZwM6+IkHBX2C9OeMAkdWWgDx
HyoCPPE+gCeoR8r8tJ7WFlu+cmRDFgfm9qYikHXMZJxVuwksPWc3U1vJ8FfYCCSB
bgmAQQMgGFwmUBuhWnN3
=gzIS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
