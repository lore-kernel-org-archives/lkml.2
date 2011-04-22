Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1DVLtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:49:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35471 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1DVLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:49:47 -0400
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 09/11] mfd: pruss CAN private data.
Date: Fri, 22 Apr 2011 17:38:27 +0530
Message-Id: <1303474109-6212-10-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PRUSS CAN data.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 include/linux/mfd/pruss.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/pruss.h b/include/linux/mfd/pruss.h
index c5e2af2..3b46156 100644
--- a/include/linux/mfd/pruss.h
+++ b/include/linux/mfd/pruss.h
@@ -92,6 +92,11 @@ struct da850_evm_pruss_suart_data {
 	int (*setup)(void);
 };
 
+struct da850_evm_pruss_can_data {
+	u32 version;
+	int (*setup)(void);
+};
+
 s32 pruss_enable(struct device *dev, u8 pruss_num);
 
 s32 pruss_load(struct device *dev, u8 pruss_num,
-- 
1.7.2.3

