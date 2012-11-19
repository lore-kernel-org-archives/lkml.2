Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2KSF3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47254 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2KSF3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:34 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 16/58] drivers/base/core.c: Mark to_root_device static
Date: Sun, 18 Nov 2012 21:27:55 -0800
Message-Id: <1353302917-13995-17-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of drivers/base/core.c references this function.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index abea76c..720441d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1399,7 +1399,7 @@ struct root_device {
 	struct module *owner;
 };
 
-inline struct root_device *to_root_device(struct device *d)
+static inline struct root_device *to_root_device(struct device *d)
 {
 	return container_of(d, struct root_device, dev);
 }
-- 
1.7.10.4

