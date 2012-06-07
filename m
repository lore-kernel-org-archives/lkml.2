Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066Ab2FGIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:25:40 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34390 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759171Ab2FGIZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:25:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAPdk0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMPAUYQJQImAgJXBxKID6YUkmWBI45wgRIDlR2JI4ZXgmI
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="923788929"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 8/9] Staging: ipack/devices/ipoctal: remove unused enum uart_parity_e.
Date: Thu,  7 Jun 2012 10:24:57 +0200
Message-Id: <1339057498-5256-8-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.h |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.h b/drivers/staging/ipack/devices/ipoctal.h
index 2aae170..c5b4ed4 100644
--- a/drivers/staging/ipack/devices/ipoctal.h
+++ b/drivers/staging/ipack/devices/ipoctal.h
@@ -20,15 +20,6 @@
 #define RELEVANT_IFLAG(iflag) ((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 
 /**
- * enum uart_parity_e - UART supported parity.
- */
-enum uart_parity_e {
-	UART_NONE  = 0,
-	UART_ODD   = 1,
-	UART_EVEN  = 2,
-};
-
-/**
  * struct ipoctal_stats -- Stats since last reset
  *
  * @tx: Number of transmitted bytes
-- 
1.7.9.5

