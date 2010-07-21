Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab0GUFSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:18:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab0GUExJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J9jTkFvDbIcCRTRYiYSX9RqODwle2ZdoGtzY6NWlLbVtcP5idm39cXK+1sZ9yPKFGY
         Pi61bqWF27Ye194+5lJg4pt4s7LfrcY3QriYju1go24hX5LlY/AI0a5OPweSkTlw5dmA
         sQPIPrNr3odo5Zp9pOiBt+ItgXZaNwM+Uz4LY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 37/37]Documentation/hwmon/via686a update web address.
Date: Tue, 20 Jul 2010 21:52:54 -0700
Message-Id: <1279687982-29413-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/via686a |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/via686a b/Documentation/hwmon/via686a
index d651b25..6f08d13 100644
--- a/Documentation/hwmon/via686a
+++ b/Documentation/hwmon/via686a
@@ -5,7 +5,7 @@ Supported chips:
   * Via VT82C686A, VT82C686B  Southbridge Integrated Hardware Monitor
     Prefix: 'via686a'
     Addresses scanned: ISA in PCI-space encoded address
-    Datasheet: On request through web form (http://www.via.com.tw/en/support/datasheets/)
+    Datasheet: On request through web form (http://www.via.com.tw/)
 
 Authors:
         Kyösti Mälkki <kmalkki@cc.hut.fi>,
-- 
1.7.1.rc1.21.gf3bd6

