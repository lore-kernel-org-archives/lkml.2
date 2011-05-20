Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab1ETASd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:18:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49259 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934585Ab1ETALf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:35 -0400
X-Sasl-enc: ZmlSMO6OxZc75xwvaZ7E0zLrCAPLpMeiHaqHmTFpYv2z 1305850294
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Karthigan Srinivasan <karthigan.srinivasan@hp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/44] drivers/base/core.c: Fixed brace coding style issue.
Date: Thu, 19 May 2011 17:10:35 -0700
Message-Id: <1305850262-9575-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>

Fixed brace coding style issue.

Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index fb8130c..bc8729d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1314,8 +1314,7 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
-struct root_device
-{
+struct root_device {
 	struct device dev;
 	struct module *owner;
 };
-- 
1.7.4.2

