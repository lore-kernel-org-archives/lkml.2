Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1LDTBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:01:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab1LDTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:28 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=we7fiOToE94A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=WUI-r05spyQwVWTg6V8A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=VVrvlI9E9_nQKi9V8YAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190025.799552511@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 11/11] Linux v3.0.12-rt30-rc2
References: <20111204185444.411298317@goodmis.org>
Content-Disposition: inline; filename=0011-Linux-v3.0.12-rt30-rc2.patch
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
index 90290c6..6eae1e4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt29
+-rt30-rc2
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO28NKAAoJEIy3vGnGbaoAnlsP/1nURgA8TkN5cpX399/xbZmO
roFF1pCfVQv8lVca60m01rEl7RNiUWPipJKqbwtQGN5IRFW22sUFayCf3XUrb42g
iROu2EXhHkTBcKBQRof+5QO+X4DWhLC3dKgqxMM45M8lKQJYOAoh0Bpzc1fMbxaJ
4GW5Nfg1JUMFwndeFmxw75XqqKz4nQmuuYmEnFeMkIaLIbg0JwUQUmZ3fOH72GHf
CIBhd+0ezw/YBpI7OHousgm0652La751SkRfEZTdGKPrEptXDQ4BIEeHyTt6xUGJ
XSmx7ubUP2FQ9ogxLIDbWeGcybHixKgrUMRe4ju1SFE7GiDayO3RbMh1uF3Rjg5v
a0e+LLsTNFWkpg9HqdaX9ZSpVR+la7tF+ZLcgT1ctj7cveIy9u6XlZpVTDWyop3F
IGWj5Eto4sceDt9z/aWVyknkYCTTmnE8KVMCYja1ARzQpea1oBppsMvCW/H5TzZ2
I3SBSTrlQeeTQlBws4C0INj4x/jVmwADPmNoZRe+HZfIK2eK1byNxv8yteXR80iw
RuioJPQnZHSWOE6h37xQI7m9DYGEafwSTF57kqrxII17kqxvH4udoMsVFwnPmTWV
r4X+ii9bz9/Lrp7ty040hIBxvqvpu+Yq521wewVr6w7uUwCeg0mLB1bp32AjasTC
Jjgk2AUIG+oXyTRy30zJ
=5+5q
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
