Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab2JWUgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:36:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37598 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839Ab2JWUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Garrett <mjg@redhat.com>, "P. Christeas" <xrg@linux.gr>
Subject: [PATCH 111/193] drivers/pci/pcie: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:04 -0700
Message-Id: <1351022666-6960-112-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Garrett <mjg@redhat.com>
CC: "P. Christeas" <xrg@linux.gr>
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

