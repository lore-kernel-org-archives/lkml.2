Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1KUVsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:48:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab1KUVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:48:04 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=QYuLm8rQNtAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Cy-xN3oWthTAw38YJ48A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111121214801.301390969@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 16:44:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 6/6] Linux 3.0.9-rt26-rc2
References: <20111121214420.124907956@goodmis.org>
Content-Disposition: inline; filename=0006-Linux-3.0.9-rt26-rc2.patch
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
index c5b71f9..1c7ebb3 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26-rc2
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOyscRAAoJEIy3vGnGbaoAw50QAMBrkpPxCCcfOQNmguaeLMPN
nF0ffx3pq5n8UDG7BB+UO+bArySPRM75hutVq0B4ACjaz+jriLcmrrWhhvv2Mbtj
HxtLTrOELjaHmOm3Xx2oKXsD0FAcqhYYeyMOSEIgPAVZSiRWbtfKrU6httxicx9Y
zCMp8t0xM4DMkv5+RvPZR5ZoatwGkwVZCPs+b32lm7P6zk1Bpq/iutgklxAYETzc
CidwHrhnNqs2mrH0sgRi4gOlVIyEYwH9iDvxaCrJrmBYZG2TIZU1gVFDIAJfDIJg
6hx/U+HZdJJn8DjUZEyk3i9cxm9cnV0SlI8knVvBQUfVLLp+n9Sy4jyLIn7hjU3E
Z9lPhB8BSQuRenVIfxxuwKbUL+SV7Ws9CPd+Uyrc94E7rKnYqfY7zB2D+ELOKGNs
uD9VReodaLcDVAnIz7VbBCn8SiB2rLRkFyDb6LyYmsEV4VIkkqFEyDnD4M094liw
lMxr7K8TX43exLj3NjCCQdq9so0hmrVswZwN2d6KcyWYnhYe4nBYmn0XPclSpOa+
HpKVz9Ky76f+ioJR0NDqCwxYJvg8w2rOs5n8DBloK4Y+gqKCyXQHLqVzGX/t6/I9
edVxV00HOhYigfTOGxL9R9B0qBlkcq4OX4Bgz1pM13f1rYESgIPCVhw/lP4lrD/+
kPOHot8qHyBEMTL4Q+og
=LDNK
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
