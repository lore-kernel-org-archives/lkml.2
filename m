Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1DRVQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:16:55 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:8967 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1DRVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:16:53 -0400
Subject: [PATCH] drivers/base/core.c: Fixed brace coding style issue.
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 16:16:52 -0500
Message-ID: <1303161412.6672.3.camel@ks-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 62183d5695ad36b6cef0fbd7617f0060f2dd391d Mon Sep 17 00:00:00 2001
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Date: Mon, 18 Apr 2011 16:05:05 -0500
Subject: [PATCH] drivers/base/core.c: Fixed brace coding style issue.

Fixed brace coding style issue.

Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
---
 drivers/base/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 81b78ed..f90346e 100644
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
1.7.1



