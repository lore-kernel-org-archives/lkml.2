Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339Ab2CNTNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:13:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16450 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab2CNTNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:13:50 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=hQ80Mz0SuLl6dlAxL6IA:9 a=PUjeQqilurYA:10 a=gyGdbLRM2qocb3wN-0YA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331752424.25686.672.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.24-rt41
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 14 Mar 2012 15:13:44 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X1BR44aNwe6LMKR4/y6K"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X1BR44aNwe6LMKR4/y6K
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.24-rt41 stable release.


This release is just an update to the new stable 3.0.24 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 90eba29b860d5b13089332ac1c6051f464658e4c


Or to build 3.0.24-rt41 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.24-rt41.=
patch.xz



Enjoy,

-- Steve



--=-X1BR44aNwe6LMKR4/y6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYO3oAAoJEIy3vGnGbaoAlzYP/Ah3Xyq8+kwk4an58AptaHqr
NvtK/SA7QimJbT5Kb04ZPWpsunQTQavd0hoViRBJLJz0rHh9d0inOfqix4HSLx9r
ln3GEp3yEyzFPBPeDJBJM8wmfwXGctfsYJ5bofYYMmu5Bg6vAprjZHGB41cp5FXs
hD3INc4/PmzBu0nqP5lOh6VNrS108kcXOFBRnilzS+K6Z5osCCEbgqysuoqPHayo
PEiuKKylCv8dSkbsvTo3rJmIbC46ZPEirLHk+MZNDVPrnZ/9asuvv8rGFBcV6+0E
CqC8liEPS0V24gXUR7pD/+s2kwCM6UfzGWo8vfVO+7JjLSvwmsN0cEjn1c9ZeFIR
f3lwIes74nfrOkGGzikE13O3F8bFKIQoFj4R1b6NCzDJDUVsjFKQ8gpUZE0Hrw++
IR2gTa+Vo2TpvpHWRExzP2jmTDANuuHGiku2nfSt5MsSM18msYcOnibrva/xdGQc
LO54ybBBnrJD39Zm+awzY9oUCSVPwbhAEgEarXdzmHEFAEf+sOCh1xKfZ89VgrEt
02Z5JlNF6o+PAjG0TUcqwutUNbVablO1V63SzcYX0JiDISlKEnNCO0auIZn+SOJf
b+BGJUJDOhE+RKwMbBErxr6An/+rnQn8sMVNwfQFZKP90mKZRfDd7tA1O8ZJI3y9
nypPsTiQlHCVdfu8f9Ax
=dRBT
-----END PGP SIGNATURE-----

--=-X1BR44aNwe6LMKR4/y6K--

