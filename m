Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0KZTFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:05:36 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46337 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0KZTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:05:33 -0500
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/16] amd64_edac: Remove explicit Kconfig PCI dependency
Date: Fri, 26 Nov 2010 20:04:17 +0100
Message-Id: <1290798263-13074-11-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1290798263-13074-1-git-send-email-bp@amd64.org>
References: <1290798263-13074-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

AMD_NB pulls in the dependency on PCI. Clarify/fix help text while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index f436a2f..fe70a34 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -75,11 +75,11 @@ config EDAC_MCE
 	bool
 
 config EDAC_AMD64
-	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && PCI && EDAC_DECODE_MCE
+	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
+	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
 	help
-	  Support for error detection and correction on the AMD 64
-	  Families of Memory Controllers (K8, F10h and F11h)
+	  Support for error detection and correction of DRAM ECC errors on
+	  the AMD64 families of memory controllers (K8 and F10h)
 
 config EDAC_AMD64_ERROR_INJECTION
 	bool "Sysfs HW Error injection facilities"
-- 
1.7.3.1.50.g1e633

