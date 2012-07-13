Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2GMP10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab2GMP1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:27:25 -0400
From: Matthew Garrett <mjg@redhat.com>
To: kys@microsoft.com
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] hv: Change the guest ID value
Date: Fri, 13 Jul 2012 11:27:03 -0400
Message-Id: <1342193223-18193-1-git-send-email-mjg@redhat.com>
In-Reply-To: <4FFFF711.8040003@redhat.com>
References: <4FFFF711.8040003@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I have to explain this I'm going to be very sad.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/hv/hyperv_vmbus.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index b9426a6..77e48b0 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -411,7 +411,7 @@ enum {
 #define HV_PRESENT_BIT			0x80000000
 
 #define HV_LINUX_GUEST_ID_LO		0x00000000
-#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
+#define HV_LINUX_GUEST_ID_HI		0x0DEFACED
 #define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI << 32) | \
 					   HV_LINUX_GUEST_ID_LO)
 
-- 
1.7.10.4

