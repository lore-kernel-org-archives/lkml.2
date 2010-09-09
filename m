Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0IIXKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:10:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49828 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab0IIWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cBGDkS9fOde+nT/uMUsTGAEiyczMt5gdPUMzj4QyqHTo8jeGh+KzeylZwj/zK6C7Fq
         oFSk/8JZgkpYge02H6jU7ZAiiTfhqD/mdmRneMcEu32/5oylhRVnttu7cTe2Jg2VCPxv
         jHm+yNHv0VlnAr9xbNQB0pbN7L16wVD7Fk3jw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 018/223]drivers/firmware/edd.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:37 -0700
Message-Id: <1284071149-7723-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
References: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/firmware/edd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index f287fe7..acabed6 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -15,7 +15,7 @@
  * made in setup.S, copied to safe structures in setup.c,
  * and presents it in sysfs.
  *
- * Please see http://linux.dell.com/edd30/results.html for
+ * Please see http://linux.dell.com/ for
  * the list of BIOSs which have been reported to implement EDD.
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.2.1

