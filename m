Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab0KORv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:51:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47960 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab0KORv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:51:26 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86,
 mrst: The shutdown for MRST requires the SCU IPC mechanism
To: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Mon, 15 Nov 2010 17:31:19 +0000
Message-ID: <20101115173110.6877.83958.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fix the build failure reported by Randy Dunlap

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9e71608..afe50ec 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -387,6 +387,7 @@ config X86_MRST
 	select APB_TIMER
 	select I2C
 	select SPI
+	select INTEL_SCU_IPC
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:

