Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab0GUFQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:16:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41629 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762071Ab0GUEx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YeQJ3k7jH4qDwr3XNHJl1lIKH3AKGvBkEeTmJW9cvA9JAjeq3Tn25hvLXRvBK3I1jJ
         7bjw+Zli6zUIvLrEy8z7KR5QG4GDBa2R4LbDcWtHMNPGFqyiE4KS48XD0i80HWPKOyIa
         eBLpMwVcR8pXchMR/7VUugPu12FSKbhZMjZqE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 49/49]Documentation/i2c/busses/i2c-sis630 update web address.
Date: Tue, 20 Jul 2010 21:53:48 -0700
Message-Id: <1279688039-29465-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/i2c/busses/i2c-sis630 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-sis630 b/Documentation/i2c/busses/i2c-sis630
index 629ea2c..0b96973 100644
--- a/Documentation/i2c/busses/i2c-sis630
+++ b/Documentation/i2c/busses/i2c-sis630
@@ -2,7 +2,7 @@ Kernel driver i2c-sis630
 
 Supported adapters:
   * Silicon Integrated Systems Corp (SiS)
-	630 chipset (Datasheet: available at http://amalysh.bei.t-online.de/docs/SIS/)
+	630 chipset (Datasheet: available at http://www.sfr-fresh.com/linux)
 	730 chipset
   * Possible other SiS chipsets ?
 
-- 
1.7.1.rc1.21.gf3bd6

