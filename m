Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1CBIiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:38:24 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57049 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1CBIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:38:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jovOcNPoKqqJ9HWzJkFHlB4w9zf8sOJviA8+1KBFOYFLOFvDQrYVoLQtDEYiPaNXXL
         yl+8RN28Fuvg2tAKD8YHxVWWRSu2HvmbnEBhUj5SoGCrBs2phkYxgN8/OX6SzZCt8IU/
         B0GNKrI7EPFywgSwzNIkpHddjsLJ96QceMfRo=
From: Liu Yuan <namei.unix@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: [RFC PATCH 1/5] x86/Kconfig: Add Page Cache Accounting entry
Date: Wed,  2 Mar 2011 16:38:06 +0800
Message-Id: <1299055090-23976-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 arch/x86/Kconfig.debug |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 615e188..f29e32d 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -304,4 +304,13 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
+config PAGE_CACHE_ACCT
+	bool "Page cache accounting"
+	---help---
+	  Enabling this options to account for page cache hit/missed number of
+	  times. This would allow user space applications get better knowledge
+	  of underlying page cache system by reading virtual file. The statitics
+	  per partition are collected.
+
+	  If unsure, say N.
 endmenu
-- 
1.7.0.4

