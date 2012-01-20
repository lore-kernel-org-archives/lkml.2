Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2ATJLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:11:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59753 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2ATJLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:11:35 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Manohar Vanga <manohar.vanga@cern.ch>,
        Martyn Welch <martyn.welch@ge.com>,
        Vincent Bossier <vincent.bossier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Emilio G. Cota" <cota@braap.org>
Cc: Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH 1/1] vme: code convention fix
Date: Fri, 20 Jan 2012 01:11:27 -0800
Message-Id: <1327050687-8907-1-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a code convention violation in vme.h

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/vme/vme.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 9d38cee..c9d65bf 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -156,7 +156,7 @@ int vme_irq_request(struct vme_dev *, int, int,
 void vme_irq_free(struct vme_dev *, int, int);
 int vme_irq_generate(struct vme_dev *, int, int);
 
-struct vme_resource * vme_lm_request(struct vme_dev *);
+struct vme_resource *vme_lm_request(struct vme_dev *);
 int vme_lm_count(struct vme_resource *);
 int vme_lm_set(struct vme_resource *, unsigned long long, u32, u32);
 int vme_lm_get(struct vme_resource *, unsigned long long *, u32 *, u32 *);
-- 
1.7.5.4

