Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab1KSEsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:48:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab1KSEsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:48:40 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=ITRB5ZnoFrQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=MLBnBCgB2_mJ4UID9zEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111119044837.774534485@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 23:45:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 5/5] Linux 3.0.9-rt26-rc1
References: <20111119044510.811163517@goodmis.org>
Content-Disposition: inline; filename=0005-Linux-3.0.9-rt26-rc1.patch
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
index c5b71f9..02556f4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26-rc1
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxzUlAAoJEIy3vGnGbaoA4eAQAIEMzm4OHCdUikyl1UPPgv1V
zsCK4qVyMqrjKLQBdPKipmHTZiwP0hFSf/XIYRKNchiAKjbDLehOyDrUJorsomOD
P+IHeMLT2OEKDYvKdhgawkt2ksjjantXAZoPIE45nrQoGldwKkRIhdSQYMDUfObY
N9W37KMIbk/yBJEQ9IACcefUhNt8uAKRqZBudhDz+F8om4aZ4PidGzpacDiHqZMt
cwPdY4YTph6zI0u1qljGFiUY698+WSzAJO4OezHctpkMd2pgOGHkWNxGJ1S3EMhy
XNgvjVhjd62x/jkWJXy7d44FtJgVee9i3ibr/Kr9WXniLuNhoItrqVebC/HfEJKV
BCnmHhaN0ITRsyldK8eBntA9KkepDtTvoYQTIfzGu/Opl7ew5WUkTyPShROEZS12
zE6BGRDn5ExMHKuOiWk/PdNNdp9LRvkn2c6VAs42GCrkatpP+kTysqR+TeSThCzr
pNF7DCSng/5wmpzXZ8ZIBIT+4TGsPRnf2T4PcnRolcdKCbzrifu5IeXntC4c4vXT
zedrCcMkng5w1QVqfXPKHipjxo6vHXqYki2Dg2thvUa/TJ0rtrA59Ue8WpmjoWJk
j02+o188s/Ee8qvbg7BkrT08FUmb/AoEB0cvKTVtIptPVvwyV/9zO3E71tpL2ffo
VmaCnUcwNCLX7Vh6in7L
=v/bG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
