Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab1BBFFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:05:49 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35350 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BBFFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p8qpf3erurPOHYcPBjArBYugRbRf3MLR2pLYDN+RzZHo4z6nyNswiXc5ahxmMOwf15
         nX12xikKrc18cZFA18OBYNFAPXNifpx8eVxHgso/6M2p/15vmdQvZCZmWqNdOzF64w5h
         F1be9mU/Ll9GadURhsQNHggbQje1QyXF1FKok=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: tony.luck@intel.com, fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/8]arch:ia64:perfmon.h change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:05:30 -0800
Message-Id: <1296623130-5130-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/include/asm/perfmon.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/perfmon.h b/arch/ia64/include/asm/perfmon.h
index 7f3333d..d551183 100644
--- a/arch/ia64/include/asm/perfmon.h
+++ b/arch/ia64/include/asm/perfmon.h
@@ -7,7 +7,7 @@
 #define _ASM_IA64_PERFMON_H
 
 /*
- * perfmon comamnds supported on all CPU models
+ * perfmon commands supported on all CPU models
  */
 #define PFM_WRITE_PMCS		0x01
 #define PFM_WRITE_PMDS		0x02
-- 
1.6.5.GIT

