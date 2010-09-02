Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0IBVOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:14:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0IBVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NE5ow43lkbiRbCo4Zc8qusGNqpB8Fkud8g82r0SimvQxMfEOoPk0M3fZXzOR6QssVV
         v/cjQlZ2Mn6pJzMEbVWbm9XVTmKDJTK0TZnMqiKOYipdt41HtXYOFg7yS9wU4kmY8Xiv
         vtOaLi7ozAW/Xy1ZTrRy6dwDB4/ijnwGZ8OJo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 87/91] arch/x86/kernel/cpu/cpufreq/powernow-k8.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:38 -0700
Message-Id: <1283462022-8024-12-git-send-email-justinmattock@gmail.com>
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
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..278dd2f 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -21,7 +21,8 @@
  *  Opteron Processors" available for download from www.amd.com
  *
  *  Tables for specific CPUs can be inferred from
- *     http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf
+ *    http://web.archive.org/web/*/http://www.amd.com/us-en/assets/content_type
+ *    /white_papers_and_tech_docs/30430.pdf 
  */
 
 #include <linux/kernel.h>
-- 
1.7.2.1

