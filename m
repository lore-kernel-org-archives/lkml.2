Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2JQKOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:14:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61738 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2JQKNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:13:52 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 5/7] staging: csr: csr_wifi_sme_sef.h: fixed indentation warnings
Date: Wed, 17 Oct 2012 19:11:05 +0900
Message-Id: <1350468667-2406-5-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350468667-2406-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350468667-2406-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indentation warnings on comments

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_sme_sef.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_sme_sef.h b/drivers/staging/csr/csr_wifi_sme_sef.h
index c874181..b40f6a7 100644
--- a/drivers/staging/csr/csr_wifi_sme_sef.h
+++ b/drivers/staging/csr/csr_wifi_sme_sef.h
@@ -1,10 +1,10 @@
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            Confidential information of CSR
+(c) Cambridge Silicon Radio Limited 2010
+Confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+Refer to LICENSE.txt included with this source for details
+on the license terms.
 
 *****************************************************************************/
 #ifndef CSR_WIFI_ROUTER_SEF_CSR_WIFI_SME_H__
-- 
1.7.9.5

