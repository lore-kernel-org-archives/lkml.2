Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab0GOSuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:50:15 -0400
Received: from nspiron-1.llnl.gov ([128.115.41.81]:10855 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934136Ab0GOSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:50:12 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 14:50:12 EDT
X-Attachments: None
Date: Thu, 15 Jul 2010 11:34:44 -0700
From: Ira Weiny <weiny2@llnl.gov>
To: Patrick Mochel <mochel@osdl.org>, Mike Murphy <mamurph@cs.clemson.edu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Lucian Adrian Grijincu <lgrijincu@ixiacom.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] Fix one more signature discrepancy between sysfs
 implementation and docs.
Message-Id: <20100715113444.68bbe2dd.weiny2@llnl.gov>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch builds on the one submitted by Bart here: http://lkml.org/lkml/2010/7/10/72

applies to linux-next.

Signed-off-by: Ira Weiny <weiny2@llnl.gov>
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
1.5.4.5

