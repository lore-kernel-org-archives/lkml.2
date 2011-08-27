Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1H0SM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:28 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54869
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751550Ab1H0SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 46/46] Staging: hv: Update the TODO file
Date: Sat, 27 Aug 2011 11:31:45 -0700
Message-Id: <1314469905-7058-46-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the TODO file.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/TODO |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
index 582fd4a..23c74ed 100644
--- a/drivers/staging/hv/TODO
+++ b/drivers/staging/hv/TODO
@@ -1,14 +1,30 @@
 TODO:
-	- fix remaining checkpatch warnings and errors
 	- audit the vmbus to verify it is working properly with the
 	  driver model
-	- see if the vmbus can be merged with the other virtual busses
-	  in the kernel
+
+		STATUS (July 19, 2011):
+		All outstanding issues (known to us)  with regards
+		to conforming to Linux Driver Model have been addressed.
+
 	- audit the network driver
 	  - checking for carrier inside open is wrong, network device API
             confusion??
+
+		STATUS (July 19, 2011):
+		The network driver has been reviewed by the community.
+		We have addressed the various issues that were raised in this
+		review.
+
 	- audit the block driver
 	- audit the scsi driver
 
+		STATUS (July 19, 2011):
+		One of the longstanding comment on this body of code
+		has been to merge the block and scsi driver. This has been done
+		and patches have been submitted. We have also addressed all the
+		review comments on this body of code.
+
+
 Please send patches for this code to Greg Kroah-Hartman <gregkh@suse.de>,
-Hank Janssen <hjanssen@microsoft.com>, and Haiyang Zhang <haiyangz@microsoft.com>.
+Hank Janssen <hjanssen@microsoft.com>, and Haiyang Zhang <haiyangz@microsoft.com>,
+K. Y. Srinivasan <kys@microsoft.com>.
-- 
1.7.4.1

