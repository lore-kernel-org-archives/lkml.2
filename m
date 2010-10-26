Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0JZBPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:15:20 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37289 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0JZBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:07 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 17/30] staging/vme: mark struct vme_master_resource's base address pointer as __iomem
Date: Mon, 25 Oct 2010 21:11:03 -0400
Message-Id: <1288055476-19438-18-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
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

