Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1CHNnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:43:21 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64427 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab1CHNnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:43:18 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 4/7] mfd: pruss SUART private data.
Date: Tue,  8 Mar 2011 19:27:43 +0530
Message-Id: <1299592667-21367-5-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PRUSS SUART data.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 include/linux/mfd/da8xx/da8xx_pru.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/da8xx/da8xx_pru.h b/include/linux/mfd/da8xx/da8xx_pru.h
index ba65ec0..2b9d426 100644
--- a/include/linux/mfd/da8xx/da8xx_pru.h
+++ b/include/linux/mfd/da8xx/da8xx_pru.h
@@ -94,6 +94,10 @@ struct da8xx_pruss_devices {
 	struct resource *resources;
 };
 
+struct da850_evm_pruss_suart_data {
+	u32 version;
+};
+
 u32 pruss_get_clk_freq(struct device *dev);
 
 s32 pruss_enable(struct device *dev, u8 pruss_num);
-- 
1.7.2.3

