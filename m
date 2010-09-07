Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab0IGEYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:24:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57922 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0IGEYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sD0iHtirHVhrsNZQKvAJdjMEz2T6+GBmNiLuS7Ij1ynpuzjeNxBAuzpvE9R4W/ookc
         rWqA0PKk8HpmhlMlCK3nPfkPD60l9ZQ204eo8tpwE1EzdguEydzUp63GCL/axffT6/aG
         uBNBpElvJj0oZMu3gnUl/q5R/NW9POnkDyYaw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]Documentation/w1/masters/mxc-w1 Fix web address to one line instead of two.
Date: Mon,  6 Sep 2010 21:24:21 -0700
Message-Id: <1283833461-26449-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283833461-26449-1-git-send-email-justinmattock@gmail.com>
References: <1283833461-26449-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned in other posts, it's better to just have the web address
as one long line instead of broken into two lines.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/w1/masters/mxc-w1 |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/w1/masters/mxc-w1 b/Documentation/w1/masters/mxc-w1
index 38be1ad..be6a1c8 100644
--- a/Documentation/w1/masters/mxc-w1
+++ b/Documentation/w1/masters/mxc-w1
@@ -5,8 +5,7 @@ Supported chips:
   * Freescale MX27, MX31 and probably other i.MX SoCs
     Datasheets:
         http://www.freescale.com/files/32bit/doc/data_sheet/MCIMX31.pdf?fpsp=1
-	http://cache.freescale.com/files/dsp/doc/archive/MCIMX27.pdf?fsrch=1&WT_TYPE=
-	Data%20Sheets&WT_VENDOR=FREESCALE&WT_FILE_FORMAT=pdf&WT_ASSET=Documentation
+	http://cache.freescale.com/files/dsp/doc/archive/MCIMX27.pdf?fsrch=1&WT_TYPE=Data%20Sheets&WT_VENDOR=FREESCALE&WT_FILE_FORMAT=pdf&WT_ASSET=Documentation
 
 Author: Originally based on Freescale code, prepared for mainline by
 	Sascha Hauer <s.hauer@pengutronix.de>
-- 
1.7.2.1

