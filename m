Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1LCBsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:48:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab1LCBsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:48:03 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=0sjakYWLR7MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=yu370ikfB7yvbRtlGfAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203014759.513445717@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:46:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 10/10] Linux v3.0.12-rt30-rc1
References: <20111203014641.165123482@goodmis.org>
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

iQIcBAABAgAGBQJO2X/PAAoJEIy3vGnGbaoAINkP/RzqgN7xLSR4s66DAenDNO21
COOE+46T/48eoXq/LVkQLPtJ3Xiu6SLkrJF8BZR+6aAeXt9cQGPVPBYBX+nBsoX1
IRuBrM0RgE1YF5hId/Ukiz6IV0AuYlbrv7nzlxM2x8ul7hg72RcGyIj0oR3yqtlK
bM4o1ESksW4v5ceW6UaSGnxViFsxUtZYe/qHCu+PMiHCpkNZH7VpQAHu8pibM1wR
NmcZdnl2qAVHYdeosJ8EmHMmOF1lME7GYs3c2SZ+3HMuwluqHUrqOETq6GbC8+iv
eM8ZaVIHhg3b/N1q4jh+AJBDA0ddGzjMSq+z7SAoIQTS6W/+Hjb6JT9z50HrNL6K
6OFrvl2U5UzBWflLb5ZKtj3UZ4YztIGLj8Xo1ZXArnGr+3KA+wAEy/+sLvxCx4ai
yMTdV3jD0e2siVb+OPOxCSXwi0HMk8OXkxLzysvPuXnSCwXUcEeadCiRPaTYJlaU
tLh3qv8cA2gFPU7BvwksYxUE/Lyc0tDYsUMdRj3laCTNCFCVCW5wxc1wdNI6BH1a
l+msl0IXDO1ZBIAtrijLj+NX6WppFqjoD4a6TpwMed1s0si2jXzg3z22KBZHz5I9
1L3aaaDf7hlXPtEhk4D7F7fz27Fi1CF1wmSG8QmAbAWrZbhkcuQCd8F3e34RxfWw
sSBLETHU8K9JXZunlDzB
=eZxO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
