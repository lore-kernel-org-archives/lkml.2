Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2CAVO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:14:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab2CAVOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:14:55 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=SNuymJkOsiB5AssflxUA:9 a=PUjeQqilurYA:10 a=_juNGhdRWUN0RjA9VzwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330636488.25686.238.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.23-rt38
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 01 Mar 2012 16:14:48 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BgMxyavNc51b5wBdS8ol"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BgMxyavNc51b5wBdS8ol
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.23-rt38 stable release.


This release is just an update to the new stable 3.0.23 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: a60fb29b526aeaa34482a062ba4244948c0b9bf1


Or to build 3.0.23-rt38 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.23.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.23-rt38.=
patch.xz



Enjoy,

-- Steve



--=-BgMxyavNc51b5wBdS8ol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPT+bIAAoJEIy3vGnGbaoAbA0QANTsaxmJFTynUOD7hor3ym1z
7C6gztjk04YD/Bl/MbaABTGFmcu+S3yWBB0rfEguJ0uEXPDhInyR+Z6dzpVATD3E
TSWKwcw9G4DjSbitpvvlQ9j/4cQ5wjdf+ic7G4762/XQQuGx71gDdzJeHeq5mMsk
Iv84IlVjF3/TEqi+3ZE1/LG2lAsKuXJosgJF9g/Bu5Kn+x74EEOVxsBZGffX/Mov
Wr3m3cWTLIQV6Lod/fQLggzqK0WU7yaBaGOnaF1bx875opBSEMKmavqfcmwIsyWY
LmCEKv7Siapp77NimQ9C0YkWU+Tma4O1EsKKHNpxGV8db0xuxWVlH424idVYNlJ7
jtTMpBhjX+2d3B0xex4NFXETmWlolczq18TBfzzkznc5P4nC5jqaSQd6uSNR/kwl
Iid7K1h8f1PHvMg6k9dMSD1yoYIhajR8dY06o7fzoJaaYxk+4WIvp8Dt7RCe0NCF
6Ny2Dyj2QYfeHHumjciGvXyVlYZ9FsoJOxtXSIB+7QphoCMPMAKc9To/J6wbNfPQ
MvAmgRq0S4kB+r5nciWGI2VzOLN2wy5cSpOrt6ke2d5V10uHMX9zaIqrAN/kVI8O
fTgQ/z5BB9cdwLN+xDQVOdodXmI9iMzhhJ95Xelf0yLZjkPU8sH7aHN84GraSXcV
BpYCEDK1HmA0gk8cgSaT
=c9uH
-----END PGP SIGNATURE-----

--=-BgMxyavNc51b5wBdS8ol--

