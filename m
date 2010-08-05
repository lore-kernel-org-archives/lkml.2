Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006Ab0HEWcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:32:36 -0400
Received: from kroah.org ([198.145.64.141]:37796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934559Ab0HEWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ira Weiny <weiny2@llnl.gov>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/28] sysfs: Fix one more signature discrepancy between sysfs implementation and docs.
Date: Thu,  5 Aug 2010 15:24:07 -0700
Message-Id: <1281047058-23716-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ira Weiny <weiny2@llnl.gov>

Signed-off-by: Ira Weiny <weiny2@llnl.gov>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index d78ed0b..5d1335f 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -4,7 +4,7 @@ sysfs - _The_ filesystem for exporting kernel objects.
 Patrick Mochel	<mochel@osdl.org>
 Mike Murphy <mamurph@cs.clemson.edu>
 
-Revised:    10 July 2010
+Revised:    15 July 2010
 Original:   10 January 2003
 
 
@@ -333,7 +333,7 @@ Structure:
 struct bus_attribute {
         struct attribute        attr;
         ssize_t (*show)(struct bus_type *, char * buf);
-        ssize_t (*store)(struct bus_type *, const char * buf);
+        ssize_t (*store)(struct bus_type *, const char * buf, size_t count);
 };
 
 Declaring:
-- 
1.7.2

