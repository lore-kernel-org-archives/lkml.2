Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab0IIW0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0IIW0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ei3nXMDPhUhwE9keXi+GAKOQTYDwxmDh8vIhKxvNMP1BXUs65Rr2rS0EnG2hbNbibt
         C6PO5h39exhKHVwtVj+GNg79/JHWk1BCN9MY8dNyMH7MGTIflIE1TcKT4Rf8MzkvCjld
         pMZYihyVoVxqPbfUdYrOjWWMN/at7NHFQJ2uw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 041/223]drivers/macintosh/therm_adt746x.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:41 -0700
Message-Id: <1284071205-7756-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/macintosh/therm_adt746x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index d0d2213..e9425b5 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -4,8 +4,8 @@
  * Copyright (C) 2003, 2004 Colin Leroy, Rasmus Rohde, Benjamin Herrenschmidt
  *
  * Documentation from
- * http://www.analog.com/UploadedFiles/Data_Sheets/115254175ADT7467_pra.pdf
- * http://www.analog.com/UploadedFiles/Data_Sheets/3686221171167ADT7460_b.pdf
+ * http://www.onsemi.com/PowerSolutions/product.do?id=ADT7467 
+ * http://www.onsemi.com/PowerSolutions/product.do?id=ADT7460 
  *
  */
 
-- 
1.7.2.1

