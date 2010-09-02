Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0IBVOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:14:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0IBVOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BsXPMSsRQi4tYx0jhiPIYj7dothQ5ptDmlWrH3F8LCwt09i+WpDfUtvv81dSY03Amw
         5Vh2DMpvrDgImXAefotJDN+xRyrdlpUR2XdehLCMRcjgWv6HMPYhZLuMEKS7pj1kw5Nj
         /Jl5nMBLrqhlaFiYbZ+ZFpyINqE84nndh3MWk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 84/91] arch/sh/cchips/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:35 -0700
Message-Id: <1283462022-8024-9-git-send-email-justinmattock@gmail.com>
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
 arch/sh/cchips/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sh/cchips/Kconfig b/arch/sh/cchips/Kconfig
index a5ab2ec..a7b70ff 100644
--- a/arch/sh/cchips/Kconfig
+++ b/arch/sh/cchips/Kconfig
@@ -17,7 +17,8 @@ config HD64461
 	  PCMCIA controller supporting 2 slots.
 
 	  More information is available at
-	  <http://semiconductor.hitachi.com/windowsce/superh/sld013.htm>.
+	  <http://web.archive.org/web/*/http://semiconductor.hitachi.com
+	  /windowsce/superh/sld013.htm>.
 
 	  Say Y if you want support for the HD64461.
 	  Otherwise, say N.
-- 
1.7.2.1

