Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1KRGH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 01:07:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60877 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab1KRGHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 01:07:55 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 31/31] Drivers: pci: probe: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 23:07:49 -0700
Message-Id: <1321596469-11180-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/pci/probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 04e74f4..d5d0ab8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1534,7 +1534,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
 		return NULL;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev){
+	if (!dev) {
 		kfree(b);
 		return NULL;
 	}
-- 
1.7.7.3

