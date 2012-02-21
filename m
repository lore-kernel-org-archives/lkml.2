Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2BUQp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:45:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2BUQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:45:57 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=aFvPiq9WAoHoafoBabYA:9 a=PUjeQqilurYA:10 a=R_UEa5kgvHPM9Pox-awA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329842751.25686.65.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.22-rt37
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 21 Feb 2012 11:45:51 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-a5oG4MPOO0l+2i8lOJIx"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a5oG4MPOO0l+2i8lOJIx
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.22-rt37 stable release.


This release is just an update to the new stable 3.0.22 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: efc2e7db8c8c870833bb8cf692601e3769efce9d


Or to build 3.0.22-rt37 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.22.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.22-rt37.=
patch.xz



Enjoy,

-- Steve



--=-a5oG4MPOO0l+2i8lOJIx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPQ8o/AAoJEIy3vGnGbaoA/9IQALOxAOPJDOl+iLZXkb7diQzv
AAsbTgo31pOHph/lFCBKhtgVxc08tcycRc1Jv5+38rOSbfbsrrxAlkctputRoH3/
n0VhSKFhT/Y/x22XIvSEXgrxTf5PIFz3Q2ILaGiJkm2m017XGbTAHXFuqyakZ9+c
EabqmXCSaPSYy+1uSykgQ3BW2DdQUUNDgvR1x51D1UIvU+m9MR6/MVWmQwkqE7s5
EEviTw77Dc3NuZJhyjZ4T7MgzuJNdGSIkxhJixvHyK2uXtmmnZiUb4G4U/09YSGy
X6XCIjr/oNR39rVxEm6Cq4/FBQRBj1v81e4zq5rxibNNM5XcJLCSWkjLyV7vQsGW
X2CF0Mh4LM7as7vIg8LLSumRJFZwC6KA9bykep6QiVRJGmiw7hmSr/JroZ3lzfgY
a/chTqcR44t3POeIg0b4LSLfk7as9mlD48EBosvgDYaBL6uUt5FQMgNhXVGT+X/Y
SoB9MtMKUR4uPN3daeiFsGwiyE+ieI2ptczOqXLImebnsnhcR/E/yL97PbBcaTjU
2QYR5shxYt18+801Htog5drH5G84nspRQX5Ifg3C1cv4Squ1eRGPIlZQ5Zuj6zso
817qjbwBQZqJExyfdYvNOEmFgwrrx9DP0KR3N2/MkCON4O4uYU3G7hRk28cBruyf
ohj2REdfP86UrPYKAEEb
=3ZWU
-----END PGP SIGNATURE-----

--=-a5oG4MPOO0l+2i8lOJIx--

