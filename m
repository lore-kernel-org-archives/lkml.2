Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1FWRYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:24:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab1FWRYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:24:02 -0400
Date: Thu, 23 Jun 2011 13:24:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172401.27701.81021.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 18/35] drivers/mmc changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mmc changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/mmc/host/sdhci-pltfm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index dbab040..6fd7336 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -24,7 +24,6 @@
 
 #include <linux/delay.h>
 #include <linux/highmem.h>
-#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 
 #include <linux/mmc/host.h>
-- 
1.7.5.4

