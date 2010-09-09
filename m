Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0IIWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab0IIWhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EqT2HVX9Y5ypW4hnbPi1OPejBwtl2gfJbe3RdP8wnai3T2fjgTey2jC1Up4bKb6aE4
         y0zTSu1r1SISI/ypUJZiyfzF3pd6tR6pTUO08ye4oP7ZQb/LWmmnsjd7cT5XkTk4FZib
         nmke0qnopqltq8+kZV4b490EC4TUsA+tjUBGA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 131/223]drivers/serial/sn_console.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:38 -0700
Message-Id: <1284071862-8194-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/serial/sn_console.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index cff9a30..daead24 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -34,7 +34,7 @@
  *
  * For further information regarding this notice, see:
  *
- * http://oss.sgi.com/projects/GenInfo/NoticeExplan
+ * http://oss.sgi.com/projects/failsafe/docs/LnxFailSafe_PG/html/fpcontent.html 
  */
 
 #include <linux/interrupt.h>
-- 
1.7.2.1

