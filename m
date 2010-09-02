Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab0IBVWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:22:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab0IBVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nME6xTWo0kTLbhbLcUXQboS6vBNshWnJjxuZ7SLrR+3W2vpFfauP/WpovWeF6atFGT
         +Sz6DVKHd4aeIKtYNUNVggk0Hoq4++B75crj7e2H/ZABMNVRzxGxW2UWH/axQFu82Jkq
         PnmfkfwjvJA71xTTvCIH79SDSBeFEgPEfPFLo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 27/91] arch/ia64/kernel/acpi.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:56 -0700
Message-Id: <1283461679-7851-12-git-send-email-justinmattock@gmail.com>
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
 arch/ia64/kernel/acpi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index c6c90f3..c33c187 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -452,7 +452,8 @@ static int get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
 
 /*
  * ACPI 2.0 SLIT (System Locality Information Table)
- * http://devresource.hp.com/devresource/Docs/TechPapers/IA64/slit.pdf
+ * http://web.archive.org/web/*/http://devresource.hp.com/
+ * devresource/Docs/TechPapers/IA64/slit.pdf 
  */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
-- 
1.7.2.1

