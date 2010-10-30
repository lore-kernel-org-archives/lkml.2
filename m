Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0J3VJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:09:35 -0400
Received: from mail.perches.com ([173.55.12.10]:3731 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0J3VJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:29 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/39] drivers/cpuidle: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:26 -0700
Message-Id: <8b71f19b52198a2f0fe1d1cac4225b76ba177728.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cpuidle/driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index fd1601e..7c9e507 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -56,7 +56,7 @@ void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
 	if (drv != cpuidle_curr_driver) {
 		WARN(1, "invalid cpuidle_unregister_driver(%s)\n",
-			drv->name);
+		     drv->name);
 		return;
 	}
 
-- 
1.7.3.1.g432b3.dirty

