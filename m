Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2JQKP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:15:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2JQKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:13:45 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/7] staging: csr: csr_wifi_sme_serialize.h: fixed indentation warnings
Date: Wed, 17 Oct 2012 19:11:02 +0900
Message-Id: <1350468667-2406-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350468667-2406-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350468667-2406-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indentation warnings from the comments.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_wifi_sme_serialize.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_sme_serialize.h b/drivers/staging/csr/csr_wifi_sme_serialize.h
index 4f3af0a..bfc180b 100644
--- a/drivers/staging/csr/csr_wifi_sme_serialize.h
+++ b/drivers/staging/csr/csr_wifi_sme_serialize.h
@@ -1,10 +1,10 @@
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2012
-            All rights reserved and confidential information of CSR
+(c) Cambridge Silicon Radio Limited 2012
+All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+Refer to LICENSE.txt included with this source for details
+on the license terms.
 
 *****************************************************************************/
 
-- 
1.7.9.5

