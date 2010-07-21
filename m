Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0GUEyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab0GUEx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K9em+W2eFEhIylQ1I1PILXpTTbqu+C06agYQr0tF86RBzIU/DAOcVgif1V4UuVzksT
         cj+Hh0CZ0PDcTx9mCKdmEKu4A3nzaCiE2XjUmTJaqw8By3gEa/baHNW0Peg4Q0U2ZKrj
         GcPyUVPmmqwT5MnnQIDi4P47XBHT45TbqwRmk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 44/44]Documentation/hwmon/w83792d update wbe address.
Date: Tue, 20 Jul 2010 21:53:01 -0700
Message-Id: <1279687982-29413-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address pointing it
to the company site due to me being unable to find it.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/w83792d |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/w83792d b/Documentation/hwmon/w83792d
index 14a668e..8a023ce 100644
--- a/Documentation/hwmon/w83792d
+++ b/Documentation/hwmon/w83792d
@@ -5,7 +5,7 @@ Supported chips:
   * Winbond W83792D
     Prefix: 'w83792d'
     Addresses scanned: I2C 0x2c - 0x2f
-    Datasheet: http://www.winbond.com.tw/E-WINBONDHTM/partner/PDFresult.asp?Pname=1035
+    Datasheet: http://www.winbond.com.tw
 
 Author: Chunhao Huang
 Contact: DZShen <DZShen@Winbond.com.tw>
-- 
1.7.1.rc1.21.gf3bd6

