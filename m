Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab0KGSVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:21:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KGSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:21:45 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=hSuQKdnXpB0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=ZlBI_vUTKDFNb1dk9f8A:9 a=J9Sjy12kCGtX2TLujSgA:7 a=VKLgghwkEINrslmkQ50tliRY32sA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sun, 07 Nov 2010 12:22:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, jj@chaosbits.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: r8712u: Remove extraneous variables from
 osdep_service.h
Message-ID: <4cd6ee5a.zGhzRELurpN2EqEs%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jesper Juhl submitted a patch to remove one extraneous variable in
this file; however, there are several others.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/osdep_service.h |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index f891a1b..7d62714 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -218,34 +218,22 @@ static inline void flush_signals_thread(void)
 
 static inline u32 _RND8(u32 sz)
 {
-	u32	val;
-
-	val = ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
-	return val;
+	return ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
 }
 
 static inline u32 _RND128(u32 sz)
 {
-	u32	val;
-
-	val = ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
-	return val;
+	return ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
 }
 
 static inline u32 _RND256(u32 sz)
 {
-	u32	val;
-
-	val = ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
-	return val;
+	return ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
 }
 
 static inline u32 _RND512(u32 sz)
 {
-	u32	val;
-
-	val = ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
-	return val;
+	return ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
 }
 
 #define STRUCT_PACKED __attribute__ ((packed))
-- 
1.7.1

