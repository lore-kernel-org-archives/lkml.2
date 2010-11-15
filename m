Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0KODFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1166 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab0KODFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:37 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ramkrishna Vepa <ramkrishna.vepa@exar.com>,
        Sivakumar Subramani <sivakumar.subramani@exar.com>,
        Sreenivasa Honnur <sreenivasa.honnur@exar.com>,
        Jon Mason <jon.mason@exar.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/44] drivers/net/vxge: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:34 -0800
Message-Id: <e86e79a18106cc38715136bfb2e880b38f5ac764.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/vxge/vxge-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 813829f..93e80c5 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -2062,7 +2062,7 @@ static irqreturn_t vxge_isr_napi(int irq, void *dev_id)
 	struct __vxge_hw_device *hldev;
 	u64 reason;
 	enum vxge_hw_status status;
-	struct vxgedev *vdev = (struct vxgedev *) dev_id;;
+	struct vxgedev *vdev = (struct vxgedev *)dev_id;
 
 	vxge_debug_intr(VXGE_TRACE, "%s:%d", __func__, __LINE__);
 
-- 
1.7.3.1.g432b3.dirty

