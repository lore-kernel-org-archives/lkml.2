Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2G3T07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:26:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab2G3T05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:26:57 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=ALvfkmUM7zsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=i_dtWveHLpIFDBgpqtUA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=8K36kPUZkLHvUTY_-hUA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120730192655.588363291@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Jul 2012 15:23:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 01/10] ktest: Remove commented exit
References: <20120730192314.144253843@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Remove-commented-exit.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

A debug 'exit' was left in ktest.pl. Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 292b13a..a40af07 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2448,7 +2448,6 @@ sub create_config {
     }
     close(OUT);
=20
-#    exit;
     make_oldconfig;
 }
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQFt//AAoJEIy3vGnGbaoA5J0QAIt5hQheEm0QE2HLy+uIbk8U
7/0gJjAYefKdxlGtv4cX8kbHkAhJtuVlsDMsSX2cOfn5BrBRoh15DhUoG6gM6Lda
b9SmFUVhzYZ/0PwGcxw1pjvj0nhfO6SXjePo0XnnfhT3g6mIqqYLlEpXEe0C0cpk
hORbU4jZBD/zuAs3+fFEH2jQQKLdGIKgu7LCqUGHg/BPMXF/RA2BFaFhL4lzz8zK
tdcDjWgEfDUMjelDo4Uw0gd49u1Wje2zqx1vUVUurZicnqsGWH3PytK5nAB39N7h
xrMNLgO+60pm/yS77QSo9z8gCwJCZrW63/FCGG2+tRkH9FZ2hhMsFLBszfPZ7eYW
dlDevsTnWAPz375EQWsW3obBqEf63wqu4brchPPqbwvWQshk76LNNrUAgAXK/qeA
1CEmlkcL0FC6ZQqt/0TL/0UjvZXKMrFz/zfRtMLFUG2peZsOeAyZCJpXlGbw9o5r
wm3IgzQ3c211g/lP3WJerpsDriD51OG+V+mLanTijHr0ckmpGcuwTJM1qMTvz+Pf
IPMhPo74tqSkfJl83Us5FWTDX8w1rUns8QhYVViUANWib8JOehqdmJXCZ4AS5JNp
RGIudlKV07ARA7cQTsRjGKcQy1lNmjZctrgW7w68DWj7Vjr21pxOpMYGGoideEDn
uk68hfK1JD/g4OR+Mm6E
=IoZJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
