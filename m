Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0GLBKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:10:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39630 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0GLBJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TqAuJ5l85QKF0tMWJ2AXUMmQGYQr5ZA86sEvpKhVowPq4cqoKhwUjASKUwxqcQiZrV
         n3UPcwMVEdG2FDGjAiFAfJ3uXsaoyOCBunvshMnCOG6BqyEA08B6kw8QLJEuD3lhfpYW
         XoXgZtO8Pt58xpR2CZpAhquGGw6g04GEfDIdA=
Subject: [PATCH] acer-wmi: remove non-used acer_quirks struct definition
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Jul 2010 09:10:22 +0800
Message-Id: <1278897022.6563.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes non-used acer_quirks struct definition.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1ea6c43..a9ca04e 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -50,17 +50,6 @@ MODULE_LICENSE("GPL");
 #define ACER_INFO KERN_INFO ACER_LOGPREFIX
 
 /*
- * The following defines quirks to get some specific functions to work
- * which are known to not be supported over ACPI-WMI (such as the mail LED
- * on WMID based Acer's)
- */
-struct acer_quirks {
-	const char *vendor;
-	const char *model;
-	u16 quirks;
-};
-
-/*
  * Magic Number
  * Meaning is unknown - this number is required for writing to ACPI for AMW0
  * (it's also used in acerhk when directly accessing the BIOS)
-- 
1.5.4.3



