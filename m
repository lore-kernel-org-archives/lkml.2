Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0IIXFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:05:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab0IIW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cThbcKMMpjDde1yElcsH1Q0l7SW9PbeJlVMC/07BDG3Vtq0gIZH1yj+R8ngX016UDR
         BlLJBAXmWbd7cQpIDhj5Ep7icrklQJUMf+x8x/MC46e3tQH4WAsAxOAbQmBcVeyjPdNA
         RBVeTZrdkjz5+60LgtmaI7ml5cYTDyMfdSGgY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 048/223]drivers/media/video/gspca/gspca.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:27:31 -0700
Message-Id: <1284071263-7789-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
References: <1284071263-7789-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/gspca/gspca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index b984610..a76b468 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2337,7 +2337,7 @@ EXPORT_SYMBOL(gspca_resume);
 /* -- cam driver utility functions -- */
 
 /* auto gain and exposure algorithm based on the knee algorithm described here:
-   http://ytse.tricolour.net/docs/LowLightOptimization.html
+   http://81.209.78.62:8080/docs/LowLightOptimization.html 
 
    Returns 0 if no changes were made, 1 if the gain and or exposure settings
    where changed. */
-- 
1.7.2.1

