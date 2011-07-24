Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1GXGIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 02:08:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60725 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1GXGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 02:08:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] of: fix missing include from of_pci.c
Date: Sun, 24 Jul 2011 00:07:53 -0600
Message-Id: <1311487673-3599-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_pci.c references symbols from linux/of.h.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/of_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index ec7b060..3701b62 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <linux/of_pci.h>
 #include <asm/prom.h>
 
-- 
1.7.4.1

