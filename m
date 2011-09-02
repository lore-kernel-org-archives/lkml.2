Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1IBOfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:35:36 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34334 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab1IBOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:35:33 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] MFD: twl6040: Add accessor for revision ID
Date: Fri,  2 Sep 2011 17:32:40 +0300
Message-Id: <1314973961-21187-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314973961-21187-1-git-send-email-peter.ujfalusi@ti.com>
References: <1314973961-21187-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For client driver to use, if they need chip resvision information.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/mfd/twl6040.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 4c806f6..cb3b822 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -225,4 +225,9 @@ unsigned int twl6040_get_sysclk(struct twl6040 *twl6040);
 int twl6040_irq_init(struct twl6040 *twl6040);
 void twl6040_irq_exit(struct twl6040 *twl6040);
 
+static inline int twl6040_get_revid(struct twl6040 *twl6040)
+{
+	return twl6040->rev;
+}
+
 #endif  /* End of __TWL6040_CODEC_H__ */
-- 
1.7.6.1

