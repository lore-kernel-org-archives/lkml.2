Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0HaTxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:53:52 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41008 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab0HaTxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:53:51 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: help with git bisecting a bug 16376: random - possibly Radeon DRM KMS related - freezes
Date: Tue, 31 Aug 2010 21:53:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33.7-tp42-toi-3.1.1.1-05125-ga817cb9; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2806958.llIXQz64ZP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201008312153.45792.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2806958.llIXQz64ZP
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi!

I am seeking help with encircling the cause of:

[Bug 16376] random - possibly Radeon DRM KMS related - freezes
https://bugzilla.kernel.org/show_bug.cgi?id=3D16376

I started a bisection as described in which has been painful for me - at=20
least for a first time bisection -, but after the second skip of a non-
booting kernel git points me to a kernel that is outside of the initial=20
range between good and back.

good is: [60b341b778cc2929df16c0a504c91621b3c6a4ad] Linux 2.6.33

bad is: bad: [64ba9926759792cf7b95f823402e2781edd1b5d4] Merge branch 'for-
linus' of git://git.open-osd.org/linux-open-osd

After skipping the last non booting kernel, git bisect put me to=20
5be796f0b842c5852d7397a82f8ebd6be8451872 which is just 300 lines after=20
2.6.33-rc2.

Obviously I am not interested in kernels prior 2.6.33. Should I just do a=20
"git bisect good" without trying the kernel or is there some other remedy?=
=20
its 11 cycles already without testing anything outside the initial=20
good/bad range and it takes about half a day to be somewhat sure that a=20
kernel is good, so I'd like to avoid testing versions outside this range.

My bug comment #35 contains a log of the bisection[1].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D16376#c35

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2806958.llIXQz64ZP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkx9XckACgkQmRvqrKWZhMcBiQCgsfIbLMyirSFCmqvFktzUIZSR
o1wAmgO1/SJqlIFumiVIHI0Q3E4GyZ8U
=CI6U
-----END PGP SIGNATURE-----

--nextPart2806958.llIXQz64ZP--
