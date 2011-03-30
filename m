Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1DCKGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:06:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61141 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1DCKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bzWCIvJKYTmY5gSo4cydLmQcxsSgB2qP++8h8PJXntgGy8XpgufB0znTlVWDrJgoMb
         DvOeMVUkV7sOH02IUvgWomv53RclPBIKrxFgAG96nbdu+aEJ6plafbcI+QtZPT9tYKgV
         ubgBU9x7tBQ1Nqk7MzfxYP3riamhu+XdvUTCw=
From: bookjovi@gmail.com
To: bookjovi@gmail.com
Cc: Russell King <linux@arm.linux.org.uk> (maintainer:ARM PRIMECELL
	BUS...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] amba: update file header info correctly
Date: Tue, 29 Mar 2011 23:37:21 -0400
Message-Id: <1301456241-2922-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

update file header info correctly after file location changed

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 drivers/amba/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 6d2bb25..52aad48 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/arm/common/amba.c
+ *  linux/drivers/amba/bus.c
  *
  *  Copyright (C) 2003 Deep Blue Solutions Ltd, All Rights Reserved.
  *
-- 
1.7.2.3

