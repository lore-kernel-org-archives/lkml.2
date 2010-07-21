Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150Ab0GUEyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:32789 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060Ab0GUExz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LJgCmItCtRajsL1oGrbEVgz8sE+xIy4PTT6JwqI7dGwntK3aJNEifiYbyB+PqUT9Z9
         CTjsK5fmcg5Xj3wLop+zWV2nA1h4ACNEhR6q1Bg90w8xgg95CBckid/i0L5jQi4gCopG
         gbn8EC61l90hYGmNYsI4+o4iBTige+G3zBqgE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 48/48]Documentation/i2c/busses/i2c-ali15x3 update web address.
Date: Tue, 20 Jul 2010 21:53:47 -0700
Message-Id: <1279688039-29465-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web to the company site due
to me unable to find the original content.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/i2c/busses/i2c-ali15x3 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-ali15x3 b/Documentation/i2c/busses/i2c-ali15x3
index 600da90..42888d8 100644
--- a/Documentation/i2c/busses/i2c-ali15x3
+++ b/Documentation/i2c/busses/i2c-ali15x3
@@ -3,7 +3,7 @@ Kernel driver i2c-ali15x3
 Supported adapters:
   * Acer Labs, Inc. ALI 1533 and 1543C (south bridge)
     Datasheet: Now under NDA
-	http://www.ali.com.tw/eng/support/datasheet_request.php
+	http://www.ali.com.tw/
 
 Authors:
 	Frodo Looijaard <frodol@dds.nl>,
-- 
1.7.1.rc1.21.gf3bd6

