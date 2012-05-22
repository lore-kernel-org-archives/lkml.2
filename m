Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab2EVPB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:01:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab2EVPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:01:54 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=ETdpiizVpPYorCdC45cA:9 a=PUjeQqilurYA:10 a=r23gT0OcB-jGfeyP-KYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337698908.13348.48.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.18-rt29
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 22 May 2012 11:01:48 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gDu268//3w/6F7Fvh5WR"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gDu268//3w/6F7Fvh5WR
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.2.18-rt29 stable release.


This release is just an update to the new stable 3.2.18 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: c96da77dcbdad05e0d707f443328e708f7cb024a


Or to build 3.2.18-rt29 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.18.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.18-rt29.=
patch.xz



Enjoy,

-- Steve



--=-gDu268//3w/6F7Fvh5WR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPu6pcAAoJEIy3vGnGbaoAPucQAJXM8QQgL/nk7pLI0oEDF+f2
SwZCIexjhMBCFU17NLKFUn7qdymFBVB+HrdioLUNCuHufGnhwJMaJHdcMJCmNm1f
5eEBBZ3PWAfgmnHOddE+gWpvLVIDkb8aieEk7Dvx1xg3aau6bqK0172liLq2lpwP
VNBRChZZXxA9B6Ljzn1YmedmnbgkrAHsGA9jpupNLxXzSRosQxi9FBcj9dpXDSci
FdqdDFQ218zagdePQLxdZTyPWls73eEtR2blbF414Czbxt1K1nyzSWNuAabV/nlv
ol4vfw/iTozOrXRNiwiP5/a/0Pzk0v9DmIZN13iA29tVfdUTDAWQw/OibvAgaiCf
HhhwTTyghSReTPEhBRza8t5+PsPObBTsilfq7plSTf81kZiZQWbzrU+BN4ThgmiR
GXXlBaC05dfwbk0QazELAmURYkEP1YMrx2Ipx+GBSY5jXNUZ++GrTa5slLUL6num
6R215OIi2BQWgH8WOug6jAz0eSAJDbJiw2sf7UY51IlCziCu0BRoaZbQDmlO7hcV
sBM/u1ef2kkRNqyGyOl2emDii3secQCIXhvnTECfPnodWNSA4XSPBK/d3qI9mbIr
BNpteBYPHTFMLeYNzrzSKDCsfmpyKvr1pgDOBfByvRUjnbo7P65rlewBZ6Zmkt94
emK4qJdYmEf+STuZQxBx
=ZCWD
-----END PGP SIGNATURE-----

--=-gDu268//3w/6F7Fvh5WR--

