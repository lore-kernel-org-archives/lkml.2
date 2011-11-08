Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1KHBam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:30:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1KHBaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:39 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Ovm7lHCGYFQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=kPKLeNUJcKth3QZMOyIA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=2ul5_yfIJEDEI7Xzr8IA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013037.980262174@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 04/10] tracing: update Documentation on max preds limit
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-update-Documentation-on-max-preds-limit.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Li Zefan <lizf@cn.fujitsu.com>

Preds is no longer stored in a fixed-size stack. The max preds now
is 2^14, and is way more than enough, so don't bother to document it.

Link: http://lkml.kernel.org/r/4EAA5E54.1080102@cn.fujitsu.com

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/events.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index b510564..bb24c2a 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -191,8 +191,6 @@ And for string fields they are:
=20
 Currently, only exact string matches are supported.
=20
-Currently, the maximum number of predicates in a filter is 16.
-
 5.2 Setting filters
 -------------------
=20
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY+AAoJEIy3vGnGbaoAhSwQAKmoKWJ0z/yVJBSwy/66DBTo
VJLwE+a/Gm2f0QGg6qreNOYOEc9Ug3Lb4hh5KoshiNzDiSYTjUUIEnaIINJjuZRi
4DB1j21e+v/odILQIQdNtMrzHFK2vCfoGOI3CLYQd9om8qX7wTvSbHRg+so7/TK9
MBCaGii4WlCncdpvR6eZ1OAtVdo0kEzOYTX5vXwQPXxRLtcTcmD5ooqoIl3bRPNj
jzVvW5Dq6NRv/QZfzatSinq9JplG5nOqbzmY+4DI0Rde1SF/v2Nb6yAdJ/C+PIh9
YFqlczo8d/5zWY5ehrSzxBGHiYmMg8U/yRKAc0r23dLydV84rJUrcc4HdWoMB5ez
XvFjEFqpPV79TrN8lPahlU5San2To4Zx8Vqwgi+BMXsEdVTAhO7kq9EWIdiFiRGR
Lm8tgugRijFiX7aW0CZrAR8GRSEXI//UnMEvkMq1eWO1lhtVfps+GZ2L0XqSbRUp
hvw46k8/ON2MdnUzj6901Um0nhAfViJ8Ht3oUcVoMa63jtWHkie4Ej+BXVv0XoDg
r/jYik1ycJwpw+eUZtoI6z1//oQG5jF2nzV+i0A4dhPL1iCsanYVXoIsiufATyWI
hyl9iaWRJoJdbl7lLGT7mSNgAFD5lg4ytsL1Y19JJkKF1EHgRFIk0sA2TX1aIHNU
NaMkzBijKdoAciMoyCYs
=cUXq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
