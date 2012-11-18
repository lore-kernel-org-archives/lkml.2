Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2KRVFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 16:05:39 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:63407 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2KRVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 16:04:50 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Nov 2012 16:04:49 EST
From: pefoley2@verizon.net
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Cc: Peter Foley <pefoley2@verizon.net>
Subject: [PATCH 4/5] silence 'arch/x86/realmode/rm/realmode.bin' is up to date
 message
Date: Sun, 18 Nov 2012 15:05:16 -0500
Message-id: <1353269117-39917-4-git-send-email-pefoley2@verizon.net>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Foley <pefoley2@verizon.net>

Since realmode.bin is in $(always) the recursive make from the realmode
directory does not need to specify a specific target.
Remove the realmode.bin target to eliminate the 'up to date'
message.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 arch/x86/realmode/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
index 94f7fbe..08fe883 100644
--- a/arch/x86/realmode/Makefile
+++ b/arch/x86/realmode/Makefile
@@ -15,4 +15,4 @@ obj-y += rmpiggy.o
 $(obj)/rmpiggy.o: $(obj)/rm/realmode.bin
 
 $(obj)/rm/realmode.bin: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/rm $@
+	$(Q)$(MAKE) $(build)=$(obj)/rm
-- 
1.8.0

