Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2I0Kl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:41:28 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:61076 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2I0Kg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnMCAEQrZFBbdWObgWdsb2JhbABFhUS4SyMBARYmJ4IhAQV5EFFXBhOICbdvkTUDlWmTFA
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447827"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 14/17] Staging: ipack: remove blank line at EOF warning in Kconfig files
Date: Thu, 27 Sep 2012 12:37:38 +0200
Message-Id: <1348742261-28145-14-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/Kconfig |    1 -
 drivers/staging/ipack/devices/Kconfig |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/ipack/bridges/Kconfig b/drivers/staging/ipack/bridges/Kconfig
index 97c837e..33fdc24 100644
--- a/drivers/staging/ipack/bridges/Kconfig
+++ b/drivers/staging/ipack/bridges/Kconfig
@@ -5,4 +5,3 @@ config BOARD_TPCI200
 	help
 	  This driver supports the TEWS TPCI200 device for the IndustryPack bus.
 	default n
-
diff --git a/drivers/staging/ipack/devices/Kconfig b/drivers/staging/ipack/devices/Kconfig
index 39f7188..0b82fdc 100644
--- a/drivers/staging/ipack/devices/Kconfig
+++ b/drivers/staging/ipack/devices/Kconfig
@@ -4,4 +4,3 @@ config SERIAL_IPOCTAL
 	help
 	  This driver supports the IPOCTAL serial port device for the IndustryPack bus.
 	default n
-
-- 
1.7.10.4

