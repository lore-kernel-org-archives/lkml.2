Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab0IBVQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:16:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56796 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab0IBVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VWZBuy8G4WLq1ME4N9WDMqn6g5U20zrO3r6Sqnr/gdYldtsnu1gTBrajFyHdMmhcSk
         RmfQQ+o3AFjqbz+yrwxYGDFKPMoBjg2q4Q/cfHj1pQxjXmU7CFSAyCAtW4AgFqeA0BOD
         eTTq2AjU1DCQNGL5lSg4SdxjXodrLWkvqI7rs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 88/91] arch/x86/kernel/cpu/amd.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:39 -0700
Message-Id: <1283462022-8024-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
References: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ba5f62f..8c03911 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -23,7 +23,7 @@
  *	contact AMD for precise details and a CPU swap.
  *
  *	See	http://www.multimania.com/poulot/k6bug.html
- *		http://www.amd.com/K6/k6docs/revgd.html
+ *		http://web.archive.org/web/*/http://www.amd.com/K6/k6docs/revgd.html	
  *
  *	The following test is erm.. interesting. AMD neglected to up
  *	the chip setting when fixing the bug but they also tweaked some
-- 
1.7.2.1

