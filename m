Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1KHQgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:36:31 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:34288
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753418Ab1KHQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:36:25 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 07/11] Staging: hv: storvsc: use the macro KBUILD_MODNAME
Date: Tue,  8 Nov 2011 09:01:46 -0800
Message-Id: <1320771710-29139-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320771710-29139-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320771710-29139-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the macro KBUILD_MODNAME.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 827bc68..916f5d0 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1444,7 +1444,7 @@ err_out0:
 /* The one and only one */
 
 static struct hv_driver storvsc_drv = {
-	.name = "storvsc",
+	.name = KBUILD_MODNAME,
 	.id_table = id_table,
 	.probe = storvsc_probe,
 	.remove = storvsc_remove,
-- 
1.7.4.1

