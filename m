Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0LFWJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:09:14 -0500
Received: from mail.perches.com ([173.55.12.10]:2337 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab0LFWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/29] drivers/cpuidle: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:59 -0800
Message-Id: <f0b634de81383fcafc2f365900087974f4ffb20e.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
1.7.3.2.245.g03276.dirty

