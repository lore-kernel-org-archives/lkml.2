Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1KUQoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:44:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53207 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab1KUQnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:43:37 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 2/3]drivers:staging:gma500:power.c Remove extra semicolon.
Date: Mon, 21 Nov 2011 08:43:27 -0800
Message-Id: <1321893808-3721-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
References: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below removes an extra semicolon.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: devel@driverdev.osuosl.org

---
 drivers/staging/gma500/power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 436fe97..441ee98 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -304,7 +304,7 @@ int psb_runtime_suspend(struct device *dev)
 
 int psb_runtime_resume(struct device *dev)
 {
-	return gma_power_resume(dev);;
+	return gma_power_resume(dev);
 }
 
 int psb_runtime_idle(struct device *dev)
-- 
1.7.5.4

