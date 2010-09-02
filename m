Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0IBVH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63611 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0IBVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QLlsdVM3SWmK1s49fr+fO/YFhiyJTtDX342ZGLVRl/x3m0fd0wLrRym5ojsPk8Qskq
         3MKuMD92SkMlkS3hxTa3jnswM8qhPtSwCsNKjmkv+nHIbKmt2Hcmuy+NgEUy5AcW9Wqu
         aHA2R7xsFpj6QUJRnAH0B3sOiQ7Q1FnoOVIeA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 19/91] arch/arm/mach-pxa/am200epd.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:48 -0700
Message-Id: <1283461679-7851-4-git-send-email-justinmattock@gmail.com>
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
 arch/arm/mach-pxa/am200epd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
index 3499fad..0fd6a08 100644
--- a/arch/arm/mach-pxa/am200epd.c
+++ b/arch/arm/mach-pxa/am200epd.c
@@ -10,7 +10,7 @@
  * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
  *
  * This work was made possible by help and equipment support from E-Ink
- * Corporation. http://support.eink.com/community
+ * Corporation. http://www.support.eink.com/
  *
  * This driver is written to be used with the Metronome display controller.
  * on the AM200 EPD prototype kit/development kit with an E-Ink 800x600
-- 
1.7.2.1

