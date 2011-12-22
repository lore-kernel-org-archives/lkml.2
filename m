Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1LVDko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:40:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1LVDkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:40:42 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=C3mFA74TiAw2U0iY504A:9 a=PUjeQqilurYA:10 a=_mwduU7UExTc1T6OJ7sA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324525237.5916.114.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.14-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 21 Dec 2011 22:40:37 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-htTxv/uGNZ57wdpXou9J"
X-Mailer: Evolution 3.0.3-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-htTxv/uGNZ57wdpXou9J
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.14-rt31 stable release.


This release is just an update to the new stable 3.0.14 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 6aaac97b2b5e0750a2739c3a247d79d4fadac43e


Or to build 3.0.14-rt31 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.14.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.14-rt31.=
patch.xz


The broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.14-rt3=
1.tar.xz

Enjoy,

-- Steve



--=-htTxv/uGNZ57wdpXou9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8qa1AAoJEIy3vGnGbaoAEdsP/2ZxYkwQwLXCZjlA87oJ2VsP
cuF7B7xulhKXcuC9dn4+5opg4THBuOnpvao1pQheFYOOTm9kKsj0homhqUCValmJ
4ZK4TXh52kOFEbCne5FJx60f7kruFuiqoPkibn09eclD6mEXkI3B56ipuWVQqAgl
5jVtfqI5Cmm7iQcqEsshk6s2ZylWQwbaynu9fv+XLFlFJBFIfrd7YbY0IXiCzxym
uUxIlmbsHM6+7yQSpHr79nXDfw1WRfGYZhYTfWbiSShLzWacKPIl1DJsIzOpwrjP
CayfnUZ2OnS5+CO5+8bxl9kOvZqIj4sn5aNoSDxXCK1HPkgeM0mr1xlJH6nxZc1l
wTrsl/G8e5GOUmX7qDYWi5ud829NxH1/PoTpNTouktJTl1XnTTkA4VMmMKlhwSON
SzJ/BfDMzrp8oJghfyHi+HEfygHqOlVlidzTWzi4xBkI+mNQq222oEnAvATmBpNG
I4Bab3HsYyJkRQuQ+aDejDQeKRPv8j9ACG5Ccisaq4Tp4hxq61PqxpE8yrRJwgmj
w3yjSz4Xr8ZRj144G/xYwMmQJlo6Smz1iZupqW+UutLsrmUc/PRnYxmQrads4Xr+
aYQPwiBZLr7QGz2E51ppSVSnWQv4yLjMCGnxzCQZTI4nj8Y6ZKNitTOH2BiKD3Mr
CVR2hu9NXjRbvyoZXGmW
=etIN
-----END PGP SIGNATURE-----

--=-htTxv/uGNZ57wdpXou9J--

