Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0GUEvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:51:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63473 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0GUEu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G5kUeMl83eCTJ1gpg2ILd8tg+bm/AVcxYFhkvjm/tQy1LGM41LQp5y2ptxOZ/gLJ2J
         4M5q/0DCH9qsCl0cZQMFVDYae4DjqRh00vIjcgAmRPYGmLsGQZ2x4QxnibZ0/RloVJLq
         JDlVSPIW3z/MZh78MRrxMU+xCa//FrbDp4Va8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]Documentation/ABI/testing/sysfs-devices-memory update web address.
Date: Tue, 20 Jul 2010 21:50:48 -0700
Message-Id: <1279687861-29282-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/ABI/testing/sysfs-devices-memory |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index aba7d98..7405de2 100644
--- a/Documentation/ABI/testing/sysfs-devices-memory
+++ b/Documentation/ABI/testing/sysfs-devices-memory
@@ -7,7 +7,7 @@ Description:
 		added or removed dynamically to represent hot-add/remove
 		operations.
 Users:		hotplug memory add/remove tools
-		https://w3.opensource.ibm.com/projects/powerpc-utils/
+		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
 
 What:		/sys/devices/system/memory/memoryX/removable
 Date:		June 2008
@@ -19,7 +19,7 @@ Description:
 		identify removable sections of the memory before attempting
 		potentially expensive hot-remove memory operation
 Users:		hotplug memory remove tools
-		https://w3.opensource.ibm.com/projects/powerpc-utils/
+		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils	
 
 What:		/sys/devices/system/memory/memoryX/phys_device
 Date:		September 2008
@@ -58,7 +58,7 @@ Description:
 		by root to offline that section.
 		# echo offline > /sys/devices/system/memory/memory22/state
 Users:		hotplug memory remove tools
-		https://w3.opensource.ibm.com/projects/powerpc-utils/
+		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
 
 
 What:		/sys/devices/system/memoryX/nodeY
-- 
1.7.1.rc1.21.gf3bd6

