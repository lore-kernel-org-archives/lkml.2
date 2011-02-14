Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1BNKkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:40:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43922 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1BNKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:40:14 -0500
From: Michal Simek <monstr@monstr.eu>
To: glikely@secretlab.ca
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        John Williams <john.williams@petalogix.com>
Subject: [PATCH] of: Add missing of_address.h to xilinx ehci driver
Date: Mon, 14 Feb 2011 11:40:09 +0100
Message-Id: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build log:
In file included from drivers/usb/host/ehci-hcd.c:1208:
drivers/usb/host/ehci-xilinx-of.c: In function 'ehci_hcd_xilinx_of_probe':
drivers/usb/host/ehci-xilinx-of.c:168: error: implicit declaration of function 'of_address_to_resource'

Signed-off-by: John Williams <john.williams@petalogix.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/usb/host/ehci-xilinx-of.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index e8f4f36..a6f21b8 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -29,6 +29,7 @@
 
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 
 /**
  * ehci_xilinx_of_setup - Initialize the device for ehci_reset()
-- 
1.5.5.6

