Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2A3Odx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:33:53 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2A3Odw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:33:52 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] cpufreq/gx: Fix the compile error
To: ak@linux.intel.com, linux-kernel@vger.kernel.org
Date: Mon, 30 Jan 2012 14:47:28 +0000
Message-ID: <20120130144720.5908.37381.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Someone forgot to test this one it seems.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/cpufreq/gx-suspmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index 5a06c0b..456bee0 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -172,7 +172,7 @@ static struct pci_device_id gx_chipset_tbl[] __initdata = {
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
 	{ 0, },
 };
-MODULE_DEVICE_TABLE(gx_chipset_tbl);
+MODULE_DEVICE_TABLE(pci, gx_chipset_tbl);
 
 static void gx_write_byte(int reg, int value)
 {

