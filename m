Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0KGSVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:21:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0KGSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:21:45 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=1OA05kddAxcA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=0azM3ZO7AAAA:8 a=yQdBAQUQAAAA:8 a=MBpkLUbaJkvONdGmUlEA:9 a=eMi3QLeMRQHhjtV5FY0egHf1tFAA:4 a=CjuIK1q_8ugA:10 a=BGWj8ct6lkoA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sun, 07 Nov 2010 12:22:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, jj@chaosbits.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: r8712u: Remove unneeded local variable in
 _malloc in osdep_service.h header
Message-ID: <4cd6ee5a.Fh7BksBGPYS8NR7m%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

The variable 'pbuf' is not needed.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Greg,

I have cleaned up the commit message in the patch from Jesper and
resubmitted it.

Larry
---

 drivers/staging/rtl8712/osdep_service.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index d1674cd..f891a1b 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -196,10 +196,7 @@ static inline void sleep_schedulable(int ms)
 
 static inline u8 *_malloc(u32 sz)
 {
-	u8 *pbuf;
-
-	pbuf =	kmalloc(sz, GFP_ATOMIC);
-	return pbuf;
+	return	kmalloc(sz, GFP_ATOMIC);
 }
 
 static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
-- 
1.7.1

