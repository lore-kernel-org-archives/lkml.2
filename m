Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab2AUDLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 22:11:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2AUDK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 22:10:59 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=SLimC-UJQSPXCd1Fy1kA:9 a=PUjeQqilurYA:10 a=GOv06XaBDmIuLXldm0MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327115453.3756.23.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.17-rt33
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 20 Jan 2012 22:10:53 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4VyH/MnErY1oStexH+WO"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4VyH/MnErY1oStexH+WO
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.17-rt33 stable release.


This release is just an update to the new stable 3.0.17 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: b4cf0136e3209f51a9f7bb9f07f71670affaf046


Or to build 3.0.17-rt33 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.17.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.17-rt33.=
patch.xz



Enjoy,

-- Steve



--=-4VyH/MnErY1oStexH+WO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPGiy9AAoJEIy3vGnGbaoAsrcP/RKyNtKo+zChVQEbERZWfjUc
9iOB+jgWRetAoPt6nGTT6Tg27Ert1qmLzO1tHK2X7Eq0gGT5fpXk0eXCHN7R6b5b
Z0tjXJEV4kPBi+BEMeJqvZ7VXNgTzGRHoihB0gypkgLNllujfXS7NS1KX7LiOcII
TsMbZsf+Go7Kzi+f4x7NazSy0Jh3g7PXdNk+j1hOSro5tcxNqYNT4QOK8zoosE11
ZtBee+w2WsJPA4mGjQF/9PXxzeeYdFvytt6QJ/f10YVW+PqmJGoyuDLmeLkcoUDa
IK1i7a4VWJ9WxuMAL7mowPdKqw7CqYk9TXlKXnW5ztkGj2/EA8HxWbKJHXs0gWk/
gdb0fN5WEtkjvFJWa5d4QxWRYBT4K0qElt9iLaZXmF7dEADxkC/BfK5GVUPpl7y2
yDlbaFwcboeQR1yYNbX90GuNoRlaBmJgfbB1JlAXlPbOkclFBdy4i7vdJSiskaBD
Wm2c058Qp15DxufP5LESKVNd3mc/sTf0BqO6W+ZBzFwdQytSOBBzlB+TJtwlAVfp
9/zHrce8XzpJaOfcw/TSEiplX7ONx3Oo4SjMgsl/pMx9yZY3GW2xCWnOice0BZe+
Oscu6a5mUoHpTs0ZhSt0W45sKZ++deCr+uQkaV5Yrt6K6SMbfm/jbGsiDiQVUXYX
tZYEe8FVV74qYHJy+ivP
=WyyY
-----END PGP SIGNATURE-----

--=-4VyH/MnErY1oStexH+WO--

