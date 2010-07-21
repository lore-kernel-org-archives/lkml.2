Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728Ab0GUHO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:14:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35544 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762617Ab0GUHOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=S+aRcZeH/O7V9yRaYi6JyYknE0FCHxxvdx9/8M6J6wQ6jylA98eV7W50ekrE0lLJ9D
         UPDg7RuT4EFHCaQCBonsmtAVBaTc5gF6fr2HF8PA+tIvBsmwWJVlQ6OKRYkS1+O85RWp
         oWD7NkcT0luW92BSi7PK+fyQASTktST24Z6wk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 43/43 v3]Documentation/hwmon/adm1026 update web address.
Date: Wed, 21 Jul 2010 00:15:05 -0700
Message-Id: <1279696505-1166-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Thomas Weber <weber@corscience.de>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>

---
 Documentation/hwmon/adm1026 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/adm1026 b/Documentation/hwmon/adm1026
index f4327db..d8fabe0 100644
--- a/Documentation/hwmon/adm1026
+++ b/Documentation/hwmon/adm1026
@@ -6,7 +6,7 @@ Supported chips:
     Prefix: 'adm1026'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
     Datasheet: Publicly available at the Analog Devices website
-               http://www.analog.com/en/prod/0,,766_825_ADM1026,00.html
+               http://www.onsemi.com/PowerSolutions/product.do?id=ADM1026
 
 Authors:
         Philip Pokorny <ppokorny@penguincomputing.com> for Penguin Computing
-- 
1.7.1.rc1.21.gf3bd6

