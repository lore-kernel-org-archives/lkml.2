Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2EBBm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:42:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27367 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab2EBBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:42:56 -0400
X-Authority-Analysis: v=2.0 cv=bcnpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=mVAHlB5rvZ18K34yU8QA:9 a=PUjeQqilurYA:10 a=zlekLZ1TLBGnGmPmj5MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335922970.14207.26.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.30-rt50
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 01 May 2012 21:42:50 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7c+QwGYL8753fJdNPo+T"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7c+QwGYL8753fJdNPo+T
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.30-rt50 stable release.


This release is just an update to the new stable 3.0.30 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 7985105c05c5e517d254d9f3666a37cc5fc33f82


Or to build 3.0.30-rt50 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.30.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.30-rt50.=
patch.xz



Enjoy,

-- Steve



--=-7c+QwGYL8753fJdNPo+T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPoJEaAAoJEIy3vGnGbaoAQqcQALe7LOf7wRa44KLLa4+8V/Qx
ttm6e8rr6At9KYya8reBmMxKez3zz07zIg5jkqNi5hSCk2F64eBdNzkfIKCZwKCX
HovmhfZ9ttaC2Jn2cLvHbidWLvC+smG+bZ/afvYJCMxMXUi9VhyJRLlNKWt+4EHo
eojdy1Mh6Ub/f6u2/b9aigg6izCMbwG+Q0CQkgOQmV7cpopRFBgCtLELYkcrBhJi
Qe7Elak2wR/M4ahT2rf/ZIconH8JhhbeScOE2uu2XNIyp3djeQMB7GGAT7NQ7lBc
4QkUSOtcjjTJny5fYhRdAy40V/fV1/BEomQo6hNLHtNrRqUMeErjp4IS9OWfUn4m
O0NxQlSAOTegJAtgA4P89KAQdpf93mXrebSezmqoDyODU/zUgpXpXOgsbMa5ay5Z
bnirKzxRZPM/E+qHTpEWQ4Yk1/h7hubksEbJMv9p/izIzFRGJjXotUJw/VF5HHbb
n4Rk/R130HleUevpc3aU+mgApUOcYmTupK5hCqbH80rcEwBDz1WKjO/XBI/7sUL8
p/dkhZqQHeSbV4mv43nmcRo2CDTPYID3+Gu5xdG7PnKp79kikSj6O8pr/rMG5Npu
EDXIJjWal34bA/gGWNYOHPDjct96lSc4G89fEQFJtkDy8oLkdxCHoSADvC2OMIBp
6MjUzzlA65LBHzwhBoy+
=qUO0
-----END PGP SIGNATURE-----

--=-7c+QwGYL8753fJdNPo+T--

