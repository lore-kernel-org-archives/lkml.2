Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab1GSS0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:26:25 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36560
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750933Ab1GSS0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:26:22 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/8] Staging: hv: tools: Fix a checkpatch warning in hv_kvp_daemon.c
Date: Tue, 19 Jul 2011 11:44:20 -0700
Message-Id: <1311101065-23417-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311101065-23417-1-git-send-email-kys@microsoft.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a checkpatch warning in hv_kvp_daemon.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/tools/hv_kvp_daemon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/tools/hv_kvp_daemon.c b/drivers/staging/hv/tools/hv_kvp_daemon.c
index 33f0f1c..c230bae 100644
--- a/drivers/staging/hv/tools/hv_kvp_daemon.c
+++ b/drivers/staging/hv/tools/hv_kvp_daemon.c
@@ -117,7 +117,7 @@ void kvp_get_os_info(void)
 
 	uname(&uts_buf);
 	os_build = uts_buf.release;
-	processor_arch= uts_buf.machine;
+	processor_arch = uts_buf.machine;
 
 	file = fopen("/etc/SuSE-release", "r");
 	if (file != NULL)
-- 
1.7.4.1

