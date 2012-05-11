Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2EKISc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:18:32 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:53214 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2EKIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:18:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKjKrE9bdWOb/2dsb2JhbABEtB6BB4IWAQV5EFFXBhOIErsMkTQElX2QQIJr
X-IronPort-AV: E=Sophos;i="4.75,570,1330902000"; 
   d="scan'208";a="513690771"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Staging: ipack: move the devices source line in Kconfig file
Date: Fri, 11 May 2012 10:17:11 +0200
Message-Id: <1336724236-21665-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain the proper order of definitions in Kconfig following the time order of
the commits.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
index 619c149..4f4b9d6 100644
--- a/drivers/staging/ipack/Kconfig
+++ b/drivers/staging/ipack/Kconfig
@@ -9,8 +9,8 @@ menuconfig IPACK_BUS
 
 if IPACK_BUS
 
-source "drivers/staging/ipack/devices/Kconfig"
-
 source "drivers/staging/ipack/bridges/Kconfig"
 
+source "drivers/staging/ipack/devices/Kconfig"
+
 endif # IPACK
-- 
1.7.10

