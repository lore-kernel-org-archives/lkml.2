Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702Ab0GUFRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:17:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39278 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab0GUExM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NUvz+JQUHaUDzRCZ4McUUQFlaOkHvhI6yEhhkANbQ7+zEFNCLRivFVACXgp+xMSqde
         6rNFmfUwf+IHmSJNddhLStr9WVjFUC2+atab0IW6TX291fjVCN4L5q0tM0xyQi5IrlKp
         TYZK3T3vb4b7cGtY0i5ftGeqmsjakf0HG6mZg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 38/38]Documentation/hwmon/smsc47m1 update web address.
Date: Tue, 20 Jul 2010 21:52:55 -0700
Message-Id: <1279687982-29413-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates the broken web addresses to the company site.
If anybody knows the locations of these let me know, and Ill
update and resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/smsc47m1 |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/Documentation/hwmon/smsc47m1 b/Documentation/hwmon/smsc47m1
index 42c8431..1b38676 100644
--- a/Documentation/hwmon/smsc47m1
+++ b/Documentation/hwmon/smsc47m1
@@ -7,13 +7,7 @@ Supported chips:
     Addresses scanned: none, address read from Super I/O config space
     Prefix: 'smsc47m1'
     Datasheets:
-        http://www.smsc.com/main/datasheets/47b27x.pdf
-        http://www.smsc.com/main/datasheets/47m10x.pdf
-        http://www.smsc.com/main/datasheets/47m112.pdf
-        http://www.smsc.com/main/tools/discontinued/47m13x.pdf
-        http://www.smsc.com/main/datasheets/47m14x.pdf
-        http://www.smsc.com/main/tools/discontinued/47m15x.pdf
-        http://www.smsc.com/main/datasheets/47m192.pdf
+        http://www.smsc.com/
   * SMSC LPC47M292
     Addresses scanned: none, address read from Super I/O config space
     Prefix: 'smsc47m2'
-- 
1.7.1.rc1.21.gf3bd6

