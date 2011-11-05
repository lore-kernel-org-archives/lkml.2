Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1KEK6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 06:58:24 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:56894 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1KEK6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 06:58:22 -0400
Date: Sat, 5 Nov 2011 11:58:18 +0100
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feuerer <peter@piie.net>
Subject: [PATCH RESEND 1/3] acerhdf: add support for Aspire 1410 BIOS
 v1.3314
Message-Id: <20111105115818.bd26dc8d.peter@piie.net>
In-Reply-To: <20111016114423.2df6271c.peter@piie.net>
References: <20111014234055.2265c524.peter@piie.net>
	<20111014234334.a87a2388.peter@piie.net>
	<20111015223210.GC16432@liondog.tnic>
	<cone.1318721291.690132.3813.1000@zopiie>
	<20111016084300.GB32343@liondog.tnic>
	<20111016114100.88295b72.peter@piie.net>
	<20111016114251.a710b196.peter@piie.net>
	<20111016114423.2df6271c.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.7; i686-pc-linux-gnu)
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
Acked-by: Borislav Petkov <petkovbb@gmail.com>
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

