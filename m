Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0IBVJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:09:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0IBVJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vfyfzi44cXVjwHJtEmxym4pXi46E1foATtrjis8/EQkVPirGHqoDeyQU+5dXNeive9
         896ZKrsNtMkfILro79FPjyMguVV6Xjd/+LM8yZHfe40Ir11XY8PH42cl/wug8ukE5UL+
         Hil3DiziKnNymskmi36Y/7koCXCgiAMB7rdDo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 44/91] arch/mips/math-emu/ieee754.h Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:09:05 -0700
Message-Id: <1283461746-7905-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
References: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/math-emu/ieee754.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/math-emu/ieee754.h b/arch/mips/math-emu/ieee754.h
index dd91733..a3d0893 100644
--- a/arch/mips/math-emu/ieee754.h
+++ b/arch/mips/math-emu/ieee754.h
@@ -1,7 +1,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  *  This program is free software; you can distribute it and/or modify it
  *  under the terms of the GNU General Public License (Version 2) as
-- 
1.7.2.1

