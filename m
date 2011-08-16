Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1HPQme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:42:34 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:44464 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1HPQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:42:32 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] docs/sysfs: Specify ABI documentation requirements
Date: Tue, 16 Aug 2011 18:42:22 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-default; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, rpearson@systemfabricworks.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161842.22536.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although it is expected nowadays that every new sysfs attribute is
documented under Documentation/ABI, this is not yet mentioned in the
kernel documentation. This patch adds a note in the sysfs
documentation about that requirement.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/filesystems/sysfs.txt |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 597f728..07235ca 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -4,7 +4,7 @@ sysfs - _The_ filesystem for exporting kernel objects.
 Patrick Mochel	<mochel@osdl.org>
 Mike Murphy <mamurph@cs.clemson.edu>
 
-Revised:    15 July 2010
+Revised:    16 August 2011
 Original:   10 January 2003
 
 
@@ -370,3 +370,11 @@ int driver_create_file(struct device_driver *, const struct driver_attribute *);
 void driver_remove_file(struct device_driver *, const struct driver_attribute *);
 
 
+Documentation
+~~~~~~~~~~~~~
+
+The sysfs directory structure and the attributes in each directory define an
+ABI between the kernel and user space. As for any ABI, it is important that
+this ABI is stable and properly documented. All new sysfs attributes must be
+documented in Documentation/ABI. See also Documentation/ABI/README for more
+information.
-- 
1.7.3.4

