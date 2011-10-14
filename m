Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab1JNVqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:46:09 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:46452 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1JNVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:46:08 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 17:46:08 EDT
Date: Fri, 14 Oct 2011 23:40:55 +0200
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
        Peter Feuerer <peter@piie.net>,
        Clay Carpenter <claycarpenter@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] acerhdf: add support for Aspire 1410 BIOS v1.3314
Message-Id: <20111014234055.2265c524.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: NjUwNDc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clay Carpenter <claycarpenter@gmail.com>

Add support for Aspire 1410 BIOS v1.3314.  Fixes the following error:

acerhdf: unknown (unsupported) BIOS version Acer/Aspire 1410/v1.3314,
please report, aborting!

Signed-off-by: Clay Carpenter <claycarpenter@gmail.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/platform/x86/acerhdf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 760c6d7..698e45c 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -161,6 +161,7 @@ static const struct bios_settings_t bios_tbl[] = {
 	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3308", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
 	{"Acer", "Aspire 1810TZ", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-- 
1.7.7

