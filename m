Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab0GUFPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:15:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50718 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762101Ab0GUEyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Sdg+WEZ95XF2qpzdRzkj5vOU+2T2RE9HkLMYsyvtxAl4PTmZ/sdJZQMJraAe+JNndJ
         UiTScAdbfyej9Le27V6Rn2Lw2wIlupoXToFILN67aSVW6XwqCVVV8fMNWK5vLQyfCG7C
         sFf1vdXNneoYRkrkmnHaj9Fb3y6ei0GHd2FCo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 51/51]Documentation/i2c/busses/i2c-ali1535 update web address.
Date: Tue, 20 Jul 2010 21:53:50 -0700
Message-Id: <1279688039-29465-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the company site
due to me being unable to locate the original content.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/i2c/busses/i2c-ali1535 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-ali1535 b/Documentation/i2c/busses/i2c-ali1535
index acbc65a..5d46342 100644
--- a/Documentation/i2c/busses/i2c-ali1535
+++ b/Documentation/i2c/busses/i2c-ali1535
@@ -3,7 +3,7 @@ Kernel driver i2c-ali1535
 Supported adapters:
   * Acer Labs, Inc. ALI 1535 (south bridge)
     Datasheet: Now under NDA
-	http://www.ali.com.tw/eng/support/datasheet_request.php
+	http://www.ali.com.tw/
 
 Authors:
 	Frodo Looijaard <frodol@dds.nl>,
-- 
1.7.1.rc1.21.gf3bd6

