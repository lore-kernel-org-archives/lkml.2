Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1BKOjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:39:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53394 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab1BKOi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:38:57 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 10/13] mfd: pruss SUART private data.
Date: Fri, 11 Feb 2011 20:21:29 +0530
Message-Id: <1297435892-28278-11-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PRUSS SUART data.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 include/linux/mfd/pruss/da8xx_pru.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/pruss/da8xx_pru.h b/include/linux/mfd/pruss/da8xx_pru.h
index 50f2ede..4230d10 100644
--- a/include/linux/mfd/pruss/da8xx_pru.h
+++ b/include/linux/mfd/pruss/da8xx_pru.h
@@ -93,6 +93,11 @@ struct da8xx_pruss_can_data {
 	u32 version;
 };
 
+struct da850_evm_pruss_suart_data {
+	u32 version;
+	struct resource resource;
+};
+
 u32 pruss_get_clk_freq(struct device *dev);
 
 u32 pruss_enable(struct device *dev, u8 pruss_num);
-- 
1.7.2.3

