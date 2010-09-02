Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0IBVXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:23:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0IBVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gYeg1YdtgDd76yJ4bwCQs3GX9wTawtZm0vAG7Y44FfQ0U2jRikFVJenSHkd8OgB29y
         UksOoNltTIzIo3dScVzPP6lkc10T+vy1xQ+naz+T6KpZ7jeSYB11SDDUMC8mPhqbbQwD
         +bnLmfZ7EUB0AaCIkWW44jwQ47cmaZ3/MJbfM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 21/91] arch/arm/include/asm/hardware/icst.h Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:50 -0700
Message-Id: <1283461679-7851-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/include/asm/hardware/icst.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/hardware/icst.h b/arch/arm/include/asm/hardware/icst.h
index 10382a3..794220b 100644
--- a/arch/arm/include/asm/hardware/icst.h
+++ b/arch/arm/include/asm/hardware/icst.h
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  *
  *  Support functions for calculating clocks/divisors for the ICST
- *  clock generators.  See http://www.icst.com/ for more information
+ *  clock generators.  See http://www.idt.com/ for more information
  *  on these devices.
  */
 #ifndef ASMARM_HARDWARE_ICST_H
-- 
1.7.2.1

