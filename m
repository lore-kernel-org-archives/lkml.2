Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab1CZBpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:45:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47002 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933194Ab1CZBoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18G8sVwaKAGbgft7CJd4HX33VhoezvdXpbIpFsvjn
	p4HB08zHEwzw/G
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 19/27] staging/spectra: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:03 +0100
Message-Id: <1301103851-16352-19-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/spectra.

WRONG -> RIGHT
occured     -> occurred

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/spectra/flash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
index a2f8200..cb8ed46 100644
--- a/drivers/staging/spectra/flash.c
+++ b/drivers/staging/spectra/flash.c
@@ -965,7 +965,7 @@ static void process_cmd_fail_abort(int *first_failed_cmd,
 	if (0 == *first_failed_cmd)
 		*first_failed_cmd = PendingCMD[idx].SBDCmdIndex;
 
-	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occured "
+	nand_dbg_print(NAND_DBG_DEBUG, "Uncorrectable error has occurred "
 		"while executing %u Command %u accesing Block %u\n",
 		(unsigned int)p_BTableChangesDelta->ftl_cmd_cnt,
 		PendingCMD[idx].CMD,
-- 
1.7.3.4

