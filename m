Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1LEXDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:03:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1LEXDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:03:12 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=_hgMz5nKKugA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Hvq9CvQ2ntWH5T5_hAAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111205230309.688674406@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 18:00:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 12/12 rc3] Linux v3.0.12-rt30-rc3
References: <20111205230046.736851081@goodmis.org>
Content-Disposition: inline; filename=0012-Linux-v3.0.12-rt30-rc3.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

---
 localversion-rt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/localversion-rt b/localversion-rt
index 90290c6..66ed5c0 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt29
+-rt30-rc3
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3U2tAAoJEIy3vGnGbaoA/OYP/RDud+le1ZMnsP8s7GWA4rkh
OhrzT8vBQqqiuVTEYmiIsH3xe0GudlUye3opMj4IN+l1CkfUK8Y9Fum+VtusR6nS
qg++3m4rIJ0QJGoNRKKHhN5QvWgLnm4qgqKhOenMIAv4N9X1DaOxWiazEBpuB5l9
G/uaROcG+ZtapWfr+OrDnE3MyvVuzNtS3hf0sxOWZ9gHYm6Xmrb6hudvmroZK6to
arMKAFXoIPlf0oxUZ51V0DhYa3QUUKT1zSlwimxpF7+TTxIFjETDL+vRXNI4RckA
7ZaEP8bcxZUThdJf41ssnfFVsS1tlSyr0KpvQn9yyYjAJbTGB2CKpjEfjvjumlmd
ApnYGMQK+YB7BRZkU1FBn35hMjGZ+X9V/Nh8vUvrGhFSWVPiW431puj/xoaZ6AhW
gxv06O93q/itB9zzUgFF+ogDjDG20g+ZxywHOkOpqOWrVDt0DJXg6qmndMUVsXPo
p2YAKqlsuGYrorV18ddUQm7UVXEQi3hj5Y9VwyWpUA+3opKHc138iwiLpNcWPPhn
Ya555CWxBiNc7gx9aZxtb9uVUROSagsDjw5/1/qwngE6z4GLE9tCy/lW2/NixPmn
1UcRAHWfKc1eAwyAKvpI8I+BWbdacEJGxgkpG38CF+DiykvZVtTR7PqnGqFIKzpg
j1Uu8HyCmK454HwosT9L
=e6Nc
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
