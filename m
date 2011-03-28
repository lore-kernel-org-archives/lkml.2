Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1C1Qc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:32:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1C1Qai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x2w7eQ3ayhvR7z3p/4z4PNxHZPfU8wHp8vjp46Jzv3B9MQ+asvHfR6vd8U0QFnculn
         YFWPLwu1j440ApBYcHNRRefJesZY3zABQwHD/GqfU/+92N1QiCAnkQ7QmXJQ1raIA0KW
         EiKTQIOs6IYbXhlmqdsuD2Yq50y8h0ThaCicI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 18/25]drivers:s390 Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:41 -0700
Message-Id: <1301329788-3423-19-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/s390/char/sclp_cpi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/char/sclp_cpi.c b/drivers/s390/char/sclp_cpi.c
index 5716487..0c8cc3e 100644
--- a/drivers/s390/char/sclp_cpi.c
+++ b/drivers/s390/char/sclp_cpi.c
@@ -10,7 +10,6 @@
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include "sclp_cpi_sys.h"
 
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

