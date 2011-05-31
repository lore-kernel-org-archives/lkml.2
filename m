Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1EaPwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab1EaPwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:52:40 -0400
Date: Tue, 31 May 2011 11:52:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155239.3558.63991.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 18/35] drivers/mmc changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mmc changes for SMBIOS and System Firmware

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
1.7.5.1

