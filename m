Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1AKAXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:23:55 -0500
Received: from kroah.org ([198.145.64.141]:45165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab1AKAXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:23:32 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] driver core: Document that device_rename() is only for networking
Date: Mon, 10 Jan 2011 16:23:25 -0800
Message-Id: <1294705405-31471-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110110234825.GA30018@kroah.com>
References: <20110110234825.GA30018@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

Document that device_rename() is not to be used by anything
other than the network core.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 46ff6c2..610d967 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1513,6 +1513,8 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * exclusion between two different calls of device_rename
  * on the same device to ensure that new_name is valid and
  * won't conflict with other devices.
+ *
+ * "Never use this function, bad things will happen" - gregkh
  */
 int device_rename(struct device *dev, const char *new_name)
 {
-- 
1.7.3.2

