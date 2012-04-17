Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2DQOMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:12:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28246 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2DQOMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:12:16 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=ocnSwVl0gY4aouACwvcA:9 a=PUjeQqilurYA:10 a=AiwGP3IMiOprmPMXhEwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334671929.28106.16.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.28-rt47
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 17 Apr 2012 10:12:09 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gXXHU9RiJKhLz6nwAMgu"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gXXHU9RiJKhLz6nwAMgu
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.28-rt47 stable release.


This release is just an update to the new stable 3.0.28 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: bdf9776ef8e286b06bd6b8a32b9e45eb6b1931bf


Or to build 3.0.28-rt47 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.28.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.28-rt47.=
patch.xz



Enjoy,

-- Steve



--=-gXXHU9RiJKhLz6nwAMgu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjXo5AAoJEIy3vGnGbaoA6lEP/A2lKZtoMIJ2tcMs66kth27p
Z1ZLFo/cYx+tKfFcvC2LvqDJGi5ggJc4Tw0EcZLMaJImvyc/VwJjt2i73QtKjMtD
nAbh78mAkHzwWJBUynf6VlSTN/20GRg0JJTeLWEroLKvHfT+ixlkqolKbvJj/XAl
mSY4wrel8GX7kZ+3hW+DgL2ycZa86hN7lVK4lG5FDMGfykz3BRdVkn1eKfRq1udo
u2xwbE9VKiohDCysVTM66y85hq75TzgEchkHeVnqRMZEcrPVDSDKUxhpe6vSBKeA
pzlwdHIoQM6ReVfRSF3JYOMKK8S3jKU0ieO27hwrNUkHwf2mBRdF2J8Old7uVLDl
C83qtN2layQfgrGjj12rOdU03FQ5iphWTYGETA1AtSFj5sY8S/U3MTWtfdeSfxJm
UTvRyGi4aMA56rhia69GgYPRNakxFmW5OFaQrb0wousBKSbwx0qspbm7wQ80pKBn
q/LIlWA/0JrTsvRRpjVTdJWCH8Opl83VJYFTLVctrmyoqx4eJ4UmVFm+tCYP52go
7WX9gyfHWxf3qVFrgQdpicqUNf1IGSwil/9HCiFE762J9NmNjXpvLMrMSPEnp3Rb
nVPm1USdC/C9TJyM5zxn5WB7s8f7XKbzItPiOAgxeniKKLxzc02K2CzPtufCqELK
J40vgSTwL0yg+1eY0wcd
=bAxh
-----END PGP SIGNATURE-----

--=-gXXHU9RiJKhLz6nwAMgu--

