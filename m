Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0IKDMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 23:12:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42832 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab0IKDM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 23:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z14pGDdMBKQQMJHhPILpNLt344mk9gqojDIBUZalSF1xEA1GZDZfCtrglymU9q6m/D
         rDeCcB6y+CNExP0VPSz+VbSM5QvtQuRx/b4pK0B9N0NT43HCWsVBQkiZPf3o3Id7Tz0r
         OI+JyBj7frTuaIyTpMu5ggaKooKeJZICp3tuU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/11]fs/nls/nls_base.c Update broken web addresses.
Date: Fri, 10 Sep 2010 20:12:44 -0700
Message-Id: <1284174771-7033-3-git-send-email-justinmattock@gmail.com>
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
 fs/nls/nls_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 44a88a9..7ef7118 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -23,7 +23,7 @@ static DEFINE_SPINLOCK(nls_lock);
 
 /*
  * Sample implementation from Unicode home page.
- * http://www.stonehand.com/unicode/standard/fss-utf.html
+ * http://web.archive.org/web/19970105220809/http://stonehand.com/unicode/standard/fss-utf.html 
  */
 struct utf8_table {
 	int     cmask;
-- 
1.7.2.1

