Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2ARDrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:47:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab2ARDrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:47:03 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=fPgVHY0dc_YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=DIThXYouwDDRunHzoAAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120118034701.041065361@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 17 Jan 2012 22:45:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 4/4] Linux 3.0.14-rt32-rc1
References: <20120118034531.335521323@goodmis.org>
Content-Disposition: inline; filename=0004-Linux-3.0.14-rt32-rc1.patch
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
index a68b433..2744705 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt31
+-rt32-rc1
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPFkC1AAoJEIy3vGnGbaoAyxgP/3lQPWyBzwteOOdTqmqQ4V9o
3hZPcerGNV8F26G9WQnuyhYXiZQ+3QoqXhpPnRVdJ7ccnqCi9IkKjByclePBgT5L
9i6Kj24LdZr3ZU1tqCRsxPesoiGA0z3YOFmNFbpdFM/F62jyP2arskSiywc5D4Lo
6vNrjp/LTwPje+D2rl7sI090d328W7NDu6/vaa3Fr+09hUOMNPO2EmTTAQN0/Arq
nkuE4EhEAaTC/bHmmCWW18vJhtE7fhOF2L0Juhu93eYXp8WppyJfhMtvbXJi1xLO
Ks1VSXay43fATDgws5hPBXPcGAhqH20cNdB3J8HuzFLR3i4UhvKceiS45ilstdJ/
e4NgAJ6MSiPmbKgGRaMQ5zbJN+/1i5IHasPtIO3m4xHvjZ7YK1u7JOwLw1A9/hwi
ykcwlWAVTFy6N8Xn0hKbzyR9oQ6DGWTgDgjXsyC5CLfu/7L9fZgnOmKoE/Ld+foN
LwcnBnPGdc5V13YNJI+cCrpmXMMCdwYOboDOJKz1mwaTbyt+WTnTJhCdNgF861HR
dXSEpCxCMQHrz+hcQMOQabDhn5wD+WIxmd0qGy8ko4rfY2ij0ZGGq2LLUOyX9qqa
J+lbdW1o1Fqj/eeNHp7Bj+5Vr2rywzysIzdAjoqzFoQnf67N12pgMgs2eRiuPcvN
ZVWNBgdixfcUARhreVdS
=6U/s
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
