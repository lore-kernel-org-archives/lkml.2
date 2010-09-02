Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0IBVJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:09:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0IBVI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DuDgSmQEMTbElnQ4Kw1F/RKH6+iITGr08X6FxOGz1gVMv8ivTard4mW1x1ydvdSFsF
         ithQXnn9FDNEDRaWnDPgWb2UCxpH2iNxC5rDRAIL5JDmbUAx5W2JNCxpdMKSvkMMJ1Us
         5fPpc+yKy2mW2X1KWoWfs8Q27GqwfvHqEdl8A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 33/91] arch/ia64/include/asm/machvec_sn2.h Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:54 -0700
Message-Id: <1283461746-7905-3-git-send-email-justinmattock@gmail.com>
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
 arch/ia64/include/asm/machvec_sn2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/machvec_sn2.h b/arch/ia64/include/asm/machvec_sn2.h
index f061a30..e9d032e 100644
--- a/arch/ia64/include/asm/machvec_sn2.h
+++ b/arch/ia64/include/asm/machvec_sn2.h
@@ -22,7 +22,7 @@
  * 
  * For further information regarding this notice, see: 
  * 
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/
  */
 
 #ifndef _ASM_IA64_MACHVEC_SN2_H
-- 
1.7.2.1

