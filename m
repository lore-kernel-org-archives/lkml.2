Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1IYSTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:19:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59929 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1IYSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:19:24 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/6] staging: et131x: Add link status to adapter struct
Date: Sun, 25 Sep 2011 19:17:53 +0100
Message-Id: <1316974677-17108-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
References: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used to determine if the link state has changed when the phydev
informs the et131x that a change has occurred (in et131x_adjust_link)

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_adapter.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 78f2894..fabc2c5 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -147,6 +147,9 @@ struct et131x_adapter {
 	/* Flags that indicate current state of the adapter */
 	u32 flags;
 
+	/* local link state, to determine if a state change has occurred */
+	int link;
+
 	/* Configuration  */
 	u8 rom_addr[ETH_ALEN];
 	u8 addr[ETH_ALEN];
-- 
1.7.6

