Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0KJAbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:31:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0KJAbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:31:17 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=EfljSHokgHwA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=f18xUnHkX5Z8xXe2Y4gA:9 a=plFAIK5nFIIwEjI3gHDchmg-eqgA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Tue, 09 Nov 2010 18:31:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: r8712u: Update TODO for sparse fixes
Message-ID: <4cd9e7fb.qxP67sfgXbNq+Y3q%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 340892d0ee008dffd70218c8eef15e478869bbf5 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 9 Nov 2010 18:26:34 -0600
Subject: [PATCH] staging: r8712u: Update TODO for sparse fixes

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Fixed to correct error.

Larry
---
 drivers/staging/rtl8712/TODO |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index 5c88821..2aa5deb 100644
--- a/drivers/staging/rtl8712/TODO
+++ b/drivers/staging/rtl8712/TODO
@@ -3,7 +3,6 @@ TODO:
 - switch to use LIB80211
 - switch to use MAC80211
 - checkpatch.pl fixes - only a few remain
-- sparse fixes
 - switch from large inline firmware file to use the firmware interface
   and add the file to the linux-firmware package.
 
-- 
1.7.1

