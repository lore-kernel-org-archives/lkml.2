Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1G2Wqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:46:30 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:37966 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1G2Wq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:46:29 -0400
Date: Sat, 30 Jul 2011 00:46:26 +0200
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
        Peter Feuerer <peter@piie.net>
Subject: [PATCH 2/3] acerhdf: add support for Aspire 1410 BIOS v1.3314
Message-Id: <20110730004626.adfa5f13.peter@piie.net>
In-Reply-To: <20110730004508.911be745.peter@piie.net>
References: <20110730004508.911be745.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clay Carpenter <claycarpenter@gmail.com>

Subject: [PATCH 2/3] acerhdf: add support for Aspire 1410 BIOS v1.3314

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
index 7a8568b..34c06ce 100644
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
1.7.6

