Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0JVHFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:05:46 -0400
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:38527 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab0JVHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:05:45 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 17/30] staging/vme: mark struct vme_master_resource's base address pointer as __iomem
Date: Fri, 22 Oct 2010 02:36:39 -0400
Message-Id: <1287729412-24356-18-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme_bridge.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index b653ec0..4c6ec31 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -20,7 +20,7 @@ struct vme_master_resource {
 	vme_cycle_t cycle_attr;
 	vme_width_t width_attr;
 	struct resource bus_resource;
-	void *kern_base;
+	void __iomem *kern_base;
 };
 
 struct vme_slave_resource {
-- 
1.7.1

