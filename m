Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1DVLtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:49:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49638 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1DVLtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:49:13 -0400
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 05/11] mfd: pruss SUART private data.
Date: Fri, 22 Apr 2011 17:38:23 +0530
Message-Id: <1303474109-6212-6-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PRUSS SUART data.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 include/linux/mfd/pruss.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/pruss.h b/include/linux/mfd/pruss.h
index 8ef25b3..c5e2af2 100644
--- a/include/linux/mfd/pruss.h
+++ b/include/linux/mfd/pruss.h
@@ -87,6 +87,11 @@
 #define PRU_INTC_CHANMAP12_HALF		(0x00010908)
 #define PRU_INTC_REGMAP_MASK		(0xFFFFFFFF)
 
+struct da850_evm_pruss_suart_data {
+	u32 version;
+	int (*setup)(void);
+};
+
 s32 pruss_enable(struct device *dev, u8 pruss_num);
 
 s32 pruss_load(struct device *dev, u8 pruss_num,
-- 
1.7.2.3

