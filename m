Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0IBVPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:15:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab0IBVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EVfnlFcuJnm9lqqj3vRUWGYC/E4VNxVI46R4KDyY5mX2e0CNbjbJQE5+eWXzw4w+99
         kjoE5GfaZ4mpeQn1jcf6oDlJOT4qG2sW/OgUumYdgl3R09LUfjBDkW8IZ0AghIICFpRC
         R7rPQn35cXNO9/0TRDJ++LhqNQS1RZQ6+RFXY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 89/91] arch/x86/kernel/apm_32.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:40 -0700
Message-Id: <1283462022-8024-14-git-send-email-justinmattock@gmail.com>
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
 arch/x86/kernel/apm_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 4c9c67b..ef07a46 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -190,7 +190,7 @@
  *
  * [This document is available free from Intel by calling 800.628.8686 (fax
  * 916.356.6100) or 800.548.4725; or via anonymous ftp from
- * ftp://ftp.intel.com/pub/IAL/software_specs/apmv11.doc.  It is also
+ * ftp://ftp.intel.com/pub/.  It is also
  * available from Microsoft by calling 206.882.8080.]
  *
  * APM 1.2 Reference:
-- 
1.7.2.1

