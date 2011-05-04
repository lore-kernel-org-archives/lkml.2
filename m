Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1EDTGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:06:33 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54110
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754868Ab1EDTGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:06:32 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: Add the necessary dependencies to hyperv Kconfig
Date: Wed,  4 May 2011 12:19:30 -0700
Message-Id: <1304536770-27199-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmbus driver dependes on ACPI and PCI subsystems. Change
Kconfig to reflect this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index 76f0756..d8c119c 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -1,6 +1,6 @@
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && m
+	depends on X86 && ACPI && m
 	default n
 	help
 	  Select this option to run Linux as a Hyper-V client operating
-- 
1.7.4.1

