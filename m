Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0IBVOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:14:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55411 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab0IBVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wehEZvjEc+cZxMmnayeJHwyKB/Dt8z40w6VvqgFUaRJ/dJhSytW0g5h8VFBh/xwHez
         Ci8xpDqBx1ALvSG+OKrbLovtOTxVZA4I45+jfs0Ss6+/u+HdEtCWFSxWYpA0K6HWrXwE
         U0yN/FuYLojRjvokzsnCwAhFL/dwu9NYEsSr8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 86/91] arch/x86/kernel/microcode_core.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:37 -0700
Message-Id: <1283462022-8024-11-git-send-email-justinmattock@gmail.com>
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
 arch/x86/kernel/microcode_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fa6551d..b9c5c54 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -12,7 +12,7 @@
  *	Software Developer's Manual
  *	Order Number 253668 or free download from:
  *
- *	http://developer.intel.com/design/pentium4/manuals/253668.htm
+ *	http://developer.intel.com/Assets/PDF/manual/253668.pdf	
  *
  *	For more information, go to http://www.urbanmyth.org/microcode
  *
-- 
1.7.2.1

