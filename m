Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0DFXSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:18:10 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:37568 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab0DFXSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:18:01 -0400
Date: Tue, 6 Apr 2010 16:17:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/2] Documentation/development-process: update staging info
Message-Id: <20100406161728.06033494.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBBC125.013A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update explanation of mmotm.
Add explanation of drivers/staging/.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/development-process/2.Process |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.34-rc3-git5.orig/Documentation/development-process/2.Process
+++ linux-2.6.34-rc3-git5/Documentation/development-process/2.Process
@@ -267,12 +267,8 @@ an appropriate subsystem tree or be sent
 development cycle, approximately 10% of the patches going into the mainline
 get there via -mm.
 
-The current -mm patch can always be found from the front page of
-
-	http://kernel.org/
-
-Those who want to see the current state of -mm can get the "-mm of the
-moment" tree, found at:
+The current -mm patch is available in the "mmotm" (-mm of the moment)
+directory at:
 
 	http://userweb.kernel.org/~akpm/mmotm/
 
@@ -307,6 +303,12 @@ volatility of linux-next tends to make i
 See http://lwn.net/Articles/289013/ for more information on this topic, and
 stay tuned; much is still in flux where linux-next is involved.
 
+Besides the mmotm and linux-next trees, the kernel source tree now contains
+the drivers/staging/ directory and many sub-directories for drivers or
+filesystems that are on their way to being added to the kernel tree
+proper, but they remain in drivers/staging/ while they still need more
+work.
+
 
 2.5: TOOLS
 
