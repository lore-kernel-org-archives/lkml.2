Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab0IBVI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab0IBVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XdYCZ2mJMQrsWQc7mXwxiB8Vr+4qLQWSvLIWeuCUA1nvjXpsqz1/pC3DBhS5JfFKj2
         Hpt3YR9+CLcCM/1Pc5ht/znrvFIPjqpC3ttMIgaYc4oW7/mjZyhNCUIrPOqPV4SMlG1d
         gKPuT4swuUbT4thRngcPBGZZ2GLevHB4RQk1g=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 32/91] arch/ia64/include/asm/numa.h Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:53 -0700
Message-Id: <1283461746-7905-2-git-send-email-justinmattock@gmail.com>
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
 arch/ia64/include/asm/numa.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/numa.h b/arch/ia64/include/asm/numa.h
index 6a8a27c..6decabb 100644
--- a/arch/ia64/include/asm/numa.h
+++ b/arch/ia64/include/asm/numa.h
@@ -52,7 +52,8 @@ extern struct node_cpuid_s node_cpuid[NR_CPUS];
 
 /*
  * ACPI 2.0 SLIT (System Locality Information Table)
- * http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf
+ * http://web.archive.org/web/*/http://devresource.hp.com/
+ * devresource/Docs/TechPapers/IA64/slit.pdf 
  *
  * This is a matrix with "distances" between nodes, they should be
  * proportional to the memory access latency ratios.
-- 
1.7.2.1

