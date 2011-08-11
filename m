Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1HKSgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:36:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1HKSgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:36:49 -0400
Date: Thu, 11 Aug 2011 14:36:43 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <363ffb1742d4213716e9fa17e27f64dcf5176584.1313085588.git.jbaron@redhat.com>
In-Reply-To: <cover.1313085588.git.jbaron@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
Subject: [PATCH 06/11] dynamic_debug: add Jason Baron as maintainer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add a maintainers entry for dynamic debug. Hopefully nobody
will object to me as maintainer...

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1f8267f..b7c52f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2297,6 +2297,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
+DYNAMIC DEBUG
+M:	Jason Baron <jbaron@redhat.com>
+S:	Maintained
+F:	lib/dynamic_debug.c
+F:	include/linux/dynamic_debug.h
+
 DZ DECSTATION DZ11 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
-- 
1.7.5.4

