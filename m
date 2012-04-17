Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2DQDzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:55:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2DQDzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:55:46 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=3ZqtafjnZthJUxeAXfYA:9 a=PUjeQqilurYA:10 a=HaLLCs0mLFoqsq1dp2cA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334634941.28106.14.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.15-rt25
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Mon, 16 Apr 2012 23:55:41 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-N4Zfl+elcy3pIhJkRFEX"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N4Zfl+elcy3pIhJkRFEX
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.2.15-rt25 stable release.


This release is just an update to the new stable 3.2.15 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: dce4487ac419e135b1e77871488304a1c1c319d7


Or to build 3.2.15-rt25 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.15.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.15-rt25.=
patch.xz



Enjoy,

-- Steve



--=-N4Zfl+elcy3pIhJkRFEX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjOm9AAoJEIy3vGnGbaoA3W4QAIgyWxHcfq/wSxiMCDx6tORs
uCFp/x3NzOT5dligVBofJeZlcxBOweRsS0Me7Rne+gYU1Q+pQBo5xgvJ394KVH95
g62VR+Dtse5ygi1S/GZc8cb2xt6HRw3/0VE6la/5a8RUwYp5LYnmmyf9BEL3Tkso
bF+OiR/r4NmXzY4M6N6GrskoJhUyAr6HZhi5HUkxgq9gFKaWVDA6QKQtlxBJmzwU
RpfdE5EimsYiK87z9THdui1z/jC6+LBb+EfXDBvy+hNG+6XN1VkRWdZ+ER81GKfp
/6z314WQL5TR45e41yEfus5mDGuFH6vst4SRN9/IMxFEpDIdIMzU2s05BeSZt++2
hQmLLkBdD7NdQe7HFUux+QSpEJnhkL6KgbDM/rbLcx6XA3WE2hjwSCDgWK49eW7R
+cjc1T0EqTV7OMNcRfYC1MHPeDLeJ6D31bqF3vRH/mAnhbGNnyaLKn9aCkhwfoQc
s2TuXw0GucAuTbXo3xBN9aor2I1GrmP51L1S/8ZaItRkl/JXIr+4BKtE/TocCHRs
TPk98wl6qEg2vWwZkf+VVH/lDeQbFLkWZYYt5Qj5w0FhxKBo3GMONSVYkC1kIhuk
YbhYofA0ghrHbfrD2Yf686Rq+CCLmr5aM3JCuRQl/1+G6apn5K5rnYnsDVZ0v7le
EIh0qzamBPiXh2XWPY8N
=4nzI
-----END PGP SIGNATURE-----

--=-N4Zfl+elcy3pIhJkRFEX--

