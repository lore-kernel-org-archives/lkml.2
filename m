Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142Ab0GUEyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762055Ab0GUExy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gdohi39Bb1RBpdLZyG2aY5RwgyBQlfuSFboTwX+YH3j1Tpe10xGOznWUjqn9gYKNgv
         BfCJ2i0QMldlMwFbQVT8acMB+X74qsMr4npONYfk6oSZwCmzZHa0hnGBS4iz8oCmF9Ih
         ruZACb9AmHY9uhJQ1FeuUT/MK/eqJQKsmwhPM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 47/47]Documentation/i2c/busses/i2c-ali1563 update web address.
Date: Tue, 20 Jul 2010 21:53:46 -0700
Message-Id: <1279688039-29465-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates the broken web address to the company site
due to me unable to find this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/i2c/busses/i2c-ali1563 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-ali1563 b/Documentation/i2c/busses/i2c-ali1563
index 5469169..41b1a07 100644
--- a/Documentation/i2c/busses/i2c-ali1563
+++ b/Documentation/i2c/busses/i2c-ali1563
@@ -3,7 +3,7 @@ Kernel driver i2c-ali1563
 Supported adapters:
   * Acer Labs, Inc. ALI 1563 (south bridge)
     Datasheet: Now under NDA
-	http://www.ali.com.tw/eng/support/datasheet_request.php
+	http://www.ali.com.tw/
 
 Author: Patrick Mochel <mochel@digitalimplant.org>
 
-- 
1.7.1.rc1.21.gf3bd6

