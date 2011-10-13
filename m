Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1JMSpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:45:35 -0400
Received: from smtp-2.sys.kth.se ([130.237.32.160]:37792 "EHLO
	smtp-2.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1JMSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:45:34 -0400
X-Greylist: delayed 1227 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 14:45:34 EDT
X-KTH-Auth: niso [89.253.77.162]
X-KTH-mail-from: niso@kth.se
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
To: mchehab@redhat.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
Subject: [PATCH] i7core_edac: fix erroneous size of static array
Date: Thu, 13 Oct 2011 20:24:54 +0200
Message-Id: <1318530294-6829-1-git-send-email-niso@kth.se>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Niklas Söderlund <niso@kth.se>
---
 drivers/edac/i7core_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 70ad892..e0f6096 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -441,7 +441,7 @@ static inline int numrow(u32 row)
 
 static inline int numcol(u32 col)
 {
-	static int cols[8] = {
+	static int cols[4] = {
 		1 << 10, 1 << 11, 1 << 12, -EINVAL,
 	};
 	return cols[col & 0x3];
-- 
1.7.7

