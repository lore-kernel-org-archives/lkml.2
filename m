Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1LJSaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 13:30:30 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51219 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1LJSaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 13:30:03 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 5/6] xen/xenbus-frontend: Make error message more clear
Date: Sat, 10 Dec 2011 19:29:50 +0100
Message-Id: <1323541791-18006-6-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323541791-18006-1-git-send-email-waldi@debian.org>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the work frontend to the error message because we now also have a
backend device.

Signed-off-by: Bastian Blank <waldi@debian.org>
---
 drivers/xen/xenbus/xenbus_dev_frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
index fb30cff..9f6be7d 100644
--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -611,7 +611,7 @@ static int __init xenbus_init(void)
 
 	err = misc_register(&xenbus_dev);
 	if (err)
-		printk(KERN_ERR "Could not register xenbus device\n");
+		printk(KERN_ERR "Could not register xenbus frontend device\n");
 	return err;
 }
 
-- 
1.7.7.3

