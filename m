Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1LCBiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:38:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1LCBh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:37:57 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=0sjakYWLR7MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=6Kjsa1CeOqHv9AiNEKkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203013754.484989161@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:37:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/10] Linux v3.0.12-rt30-rc1
References: <20111203013653.090501690@goodmis.org>
Content-Disposition: inline; filename=0010-Linux-v3.0.12-rt30-rc1.patch
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
index 90290c6..96edf41 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt29
+-rt30-rc1
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X1yAAoJEIy3vGnGbaoAeKsQAKgtGFbJW2VT4IE8PSYfz9+P
aeditkDnYY/uX2lAQVlP37UCo1lHcDEA3MHCHMz3RLUsDIPwnZxShSZdLKhkizWc
hVu2514uG0Iuxm/2HmVHQxGa+uZR31mx8vprIn8s7y9Lr8YeFV46nc5CkUtWUHPX
1h+22aeoEf4vcpHtjPFY53xRHBqinvFoursnXp4LMOYqucL7IYGnLXHCDwJr/mbb
peCdHtyUu52Ljbg2ggKrq1scbsM3OlpPTO1GiSTiT2fy6AzehotErQYRw8qpleyd
7s+fsG8hTj5YWj4HgQMAQsmnVx1F8D7MdKcV4vOPfrpk2n2A4h8dyE7rFKjAO+YB
0wuPJ20k7IthhjxbsiSe0VMuiTnOu2Hresy8dvk6lgcTafg+YMGMPe/iWoUZ4DmE
3PZIEaVS9Love4KbVWqilZC68+G4eH71+W5142G+f8U1bqdCz9rm4OjZUseAO13s
c5zZYpHLOSgQCwejBS3n292VrkLK7CM2p9K6ArUp2zoa3rQwErCKMt0FDn/NwC1T
s6TzbUJ0Yq66KCQY36Xb4t+uUA8el9h3NMIOENz94qp3JvFeMQGOMKIJC7FCzqRV
CavoMA5DqcrjbumdWMhj0ajJbH2Hwrs1loCyYN9NrEvwnnC8zgHwsRIXxdu4R5ku
rpgDFcxuw0r5EnZ84z8x
=ekBF
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
