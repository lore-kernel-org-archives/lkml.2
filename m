Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1HBTTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:19:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64883 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab1HBTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:19:05 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: Rename et131x_config_global_regs > et131x_configure_global_regs
Date: Tue,  2 Aug 2011 20:17:50 +0100
Message-Id: <1312312672-3639-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1312312672-3639-1-git-send-email-mark.einon@gmail.com>
References: <1312312672-3639-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in header file. Also renaming a few adapter references to fit in with the rest of the file.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 9523a8b..91fafc0 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -49,10 +49,10 @@
  */
 
 /* et131x_eeprom.c */
-int et131x_init_eeprom(struct et131x_adapter *etdev);
+int et131x_init_eeprom(struct et131x_adapter *adapter);
 
 /* et131x_initpci.c */
-void et131x_config_global_regs(struct et131x_adapter *pAdapter);
+void et131x_configure_global_regs(struct et131x_adapter *adapter);
 void et131x_enable_interrupts(struct et131x_adapter *adapter);
 void et131x_disable_interrupts(struct et131x_adapter *adapter);
 void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-- 
1.7.4.4

