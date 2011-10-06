Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab1JFU6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:58:08 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:49561 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759072Ab1JFU6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:58:06 -0400
Subject: [PATCH] [TRIVIAL] Fix printk typo 'bluestooth'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 22:57:56 +0200
Message-ID: <1317934676.1933.10.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7bd829f..7b82868 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4007,7 +4007,7 @@ static void bluetooth_shutdown(void)
 		pr_notice("failed to save bluetooth state to NVRAM\n");
 	else
 		vdbg_printk(TPACPI_DBG_RFKILL,
-			"bluestooth state saved to NVRAM\n");
+			"bluetooth state saved to NVRAM\n");
 }
 
 static void bluetooth_exit(void)
-- 
Untested, once again...

1.7.4.4



