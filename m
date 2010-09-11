Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0IKDNC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:13:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61132 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0IKDMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LqLT7wZhHIfz3uAhxccKFXQQA+p//lzPz2tVda3U09JoPO5DPdGM3/G8Q+LlmhzmO4
         Ux+mv3rWMGbNZhE2lDWa2BWCbx4qc/4Xc/Dr4exze8wVybAe6yRrgTEREW8dO5w9Bf0u
         Ndzww2M6ah5L4x15i9h7uSI2QOsbKYc03VZao=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/11]fs/nls/nls_euc-jp.c Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:46 -0700
Message-Id: <1284174771-7033-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
References: <1284174771-7033-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 fs/nls/nls_euc-jp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 7424929..d7d5526 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -3,7 +3,7 @@
  *
  * Added `OSF/JVC Recommended Code Set Conversion Specification
  * between Japanese EUC and Shift-JIS' support: <hirofumi@mail.parknet.co.jp>
- * (http://www.opengroup.or.jp/jvc/cde/sjis-euc-e.html)
+ * (http://www.opengroup.or.jp/)
  */
 
 #include <linux/module.h>
-- 
1.7.2.1

