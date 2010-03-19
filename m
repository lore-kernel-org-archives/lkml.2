Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0CSPWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:22:31 -0400
Received: from kroah.org ([198.145.64.141]:45910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab0CSPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/12] driver-core: fix missing kernel-doc in firmware_class
Date: Fri, 19 Mar 2010 08:18:50 -0700
Message-Id: <1269011935-8886-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning in firmware_class.c:

Warning(drivers/base/firmware_class.c:94): No description found for parameter 'attr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index fc7565c..18518ba 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -78,6 +78,7 @@ firmware_timeout_show(struct class *class,
 /**
  * firmware_timeout_store - set number of seconds to wait for firmware
  * @class: device class pointer
+ * @attr: device attribute pointer
  * @buf: buffer to scan for timeout value
  * @count: number of bytes in @buf
  *
-- 
1.7.0.2

