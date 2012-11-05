Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2KEXZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:25:20 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58952 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab2KEXFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:25 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 067/104] drivers/pci/pcie: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:24 -0800
Message-Id: <1352156701-4038-68-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/pci/pcie/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 6c8bc58..fde4a32 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -82,4 +82,4 @@ endchoice
 
 config PCIE_PME
 	def_bool y
-	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI
+	depends on PCIEPORTBUS && PM_RUNTIME && ACPI
-- 
1.7.9.5

