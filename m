Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab0IKE1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 00:27:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0IKE1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 00:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oyG+OgV7/z8hYeCyNuYAiwOvKIxnyeiaqNdOyRVysUb+NUPGjD7vy4yZSQkBrVv/Fy
         GQbHYTzJ2KZD9GY0wrFui1Mqhj2c/lgnlspv/HoV1gw8OHzQr7IbvRnPpIJIm2Uhc+W9
         hPS/M6LdrzqU17bxsAhaYBna01sOLoPxjhyUs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/10]include/linux/fdreg.h Update broken web addresses.
Date: Fri, 10 Sep 2010 21:27:52 -0700
Message-Id: <1284179277-7788-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
References: <1284179277-7788-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/fdreg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fdreg.h b/include/linux/fdreg.h
index c2eeb63..b153223 100644
--- a/include/linux/fdreg.h
+++ b/include/linux/fdreg.h
@@ -89,7 +89,7 @@
 /* the following commands are new in the 82078. They are not used in the
  * floppy driver, except the first three. These commands may be useful for apps
  * which use the FDRAWCMD interface. For doc, get the 82078 spec sheets at
- * http://www-techdoc.intel.com/docs/periph/fd_contr/datasheets/ */
+ * http://www.intel.com/p/en_US/business/design */
 
 #define FD_PARTID		0x18	/* part id ("extended" version cmd) */
 #define FD_SAVE			0x2e	/* save fdc regs for later restore */
-- 
1.7.2.1

