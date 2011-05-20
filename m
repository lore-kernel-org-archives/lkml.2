Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab1ETASt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:18:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42151 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685Ab1ETALb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:31 -0400
X-Sasl-enc: J1WDPP+rqGQ+CHy6N3QDS7RkBWWGxUNDerAvB6YFDsgd 1305850290
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/44] drivers:misc:ti-st: remove rfkill dependency
Date: Thu, 19 May 2011 17:10:33 -0700
Message-Id: <1305850262-9575-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

rfkill is no longer used by Texas Instruments shared transport driver to
communicate with user-space.
This patch removes the dependency of rfkill to be enabled to build
shared transport driver in the Kconfig.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
index 2c8c3f3..7c3e106 100644
--- a/drivers/misc/ti-st/Kconfig
+++ b/drivers/misc/ti-st/Kconfig
@@ -5,7 +5,6 @@
 menu "Texas Instruments shared transport line discipline"
 config TI_ST
 	tristate "Shared transport core driver"
-	depends on RFKILL
 	select FW_LOADER
 	help
 	  This enables the shared transport core driver for TI
-- 
1.7.4.2

