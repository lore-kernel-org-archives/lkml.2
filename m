Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1BYGK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:10:59 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54693 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1BYGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oTY+MAtiMZVjnapbTNf0Xs72piO6/gIWW/VzopjedvSUNM4xcxI2d7mBcIJ0yP/ZX3
         kTQ6jVrUybCNz6zIXtJ9u/8uJVONq8HV5pxpcTPjueN/9RuLxIRKf8/xAKS+wfuk7uSL
         +t7s9kWe92jFEKyY+3f6zPTUTxkClA88Jl0Vw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/21]drivers:parport:parport_mfc3.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:10:39 -0800
Message-Id: <1298614239-3571-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/parport/parport_mfc3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 362db31..1c0c642 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -397,7 +397,7 @@ static void __exit parport_mfc3_exit(void)
 
 
 MODULE_AUTHOR("Joerg Dorchain <joerg@dorchain.net>");
-MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Paralllel Port");
+MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Parallel Port");
 MODULE_SUPPORTED_DEVICE("Multiface 3 Parallel Port");
 MODULE_LICENSE("GPL");
 
-- 
1.7.4.1

