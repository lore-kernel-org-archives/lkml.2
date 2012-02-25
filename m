Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2BYRj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 12:39:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab2BYRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 12:39:31 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=58y3GYxvToQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=s4fC7zH7aWF6EWKd06cA:9 a=QEXdDO2ut3YA:10 a=JovCX9416fCreUQcMyIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120225173548.977089274@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 25 Feb 2012 12:35:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL][v3.3] x86: Fix up CFI for the nested NMI
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Jan posted a patch that fixes the CFI annotations. I recommend getting
this into 3.3 as this is new code and it would be nice to have CFI
correct. It also does a little simplification of it as well.

The second patch is comment changes only (very low impact on messing
anything up). I realized that the comments had some references to
previous approaches that I tried, and I fixed them to reflect what
the final result was. I also added some more comments to describe
the code a bit better.

Thanks,

-- Steve

Please pull the latest tip/x86/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/urgent

Head SHA1: 79fb4ad63e8266ffac1f69bbb45a6f86570493e7


Jan Beulich (1):
      x86-64: Fix CFI annotations for NMI nesting code

Steven Rostedt (1):
      x86: Fix the NMI nesting comments

----
 arch/x86/kernel/entry_64.S |   64 ++++++++++++++++++++++++----------------=
----
 1 files changed, 35 insertions(+), 29 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPSRzNAAoJEIy3vGnGbaoApBMP/1bB4SYj6rEsOhcKa1sxJvBp
wL6S/20cNvwYdbt/HVcBmvmStRFAbsHSqt8808lqMFS00Q4vOhEQGBl82oMm3Dkj
jp1gXTwVD9GCV8ekWGqybkocbEH+bKJeO2T/S11Lt9RokFHIqpVqP8+CSgRWems+
SKi2x+JIq4jsBMmB2Q1MBBKrYoW73B4KBDZj9mlMqoQwgTxQSNDlhkrWMpQXW7mi
n54V1dZqK31RTZjGibtQUXLJwordjn164X5z9G5f9+sLF283vmUXlAZN+gkPNTK1
lIU0jELRZT5gfVEn8uZ8oBzrSkmJdpZH17ntA8GNJi+yIwgkQQ+3WxHkjTg5rQs5
pPJT+FGutfUaxm+Z3pmELDCaAVhUj8cxKANX1OBMT6R8fY+eemQ+esvUa38kiVCh
aMfGjLgqtZxV9OhZixJv/Bc8qkGdkjJHQRBfpwkQ6r7FW84LtcvS1JoU16REWshz
+gQrEwuU8mlR+H59egOiYkIFSNDCDBimlT+1+ATh9IkuezwhYF+Ky9+uY1VGKuIj
qFUwx2GiiEAEhGkInv/e6wrMzg+xY3owCXuwA9L5mPu78KKMt6FCiGzB3cgQO+ic
v6AmQFHl6tqZH3Kch9gy4Vj+2Eq/g6VtpO33TObjL07k9b0Bahzsts+0KbgM+cEH
Cn8pFKOH+3kM/jHdLNqT
=mBuL
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
