Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0IIW2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:28:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36527 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab0IIW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=habow1y7jdn8vOXAOMpusKm6izRDjy91wkl651s3XQlQRyaPVh4XzO5LuwYwll7FtH
         vG1SQd4f43EnHXiKlvs4i6CkAyf00wpFHcJHfaGJ73PzZwN4PnnmefmsskLjz94URb0N
         I9FMsjizniN08/nTfuK0aN7jlnNrv6kZjVdpA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 074/223]drivers/media/dvb/frontends/mt312.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:28:35 -0700
Message-Id: <1284071316-7834-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071316-7834-1-git-send-email-justinmattock@gmail.com>
References: <1284071316-7834-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/dvb/frontends/mt312.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 472907d..5172311 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -20,8 +20,9 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
     References:
-    http://products.zarlink.com/product_profiles/MT312.htm
-    http://products.zarlink.com/product_profiles/SL1935.htm
+    http://www.zarlink.com/zarlink/hs/71.htm 
+    http://www.chipcatalog.com/Zarlink/MT312.htm
+    http://www.chipcatalog.com/Zarlink/SL1935.htm
 */
 
 #include <linux/delay.h>
-- 
1.7.2.1

