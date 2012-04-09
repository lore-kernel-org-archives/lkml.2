Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2DIIhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:37:05 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10304 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2DIIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:37:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Apr 2012 01:36:51 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] mfd: rc5t583: add rc5t583's gpio in mfd device list
Date: Mon,  9 Apr 2012 13:55:55 +0530
Message-Id: <1333959955-968-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1333959955-968-1-git-send-email-ldewangan@nvidia.com>
References: <1333959955-968-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the gpio of RC583 in the list of rc583 mfd devices
to register the gpio driver of RC5T583.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/rc5t583.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 99ef944..3439d3e 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -75,6 +75,7 @@ static struct deepsleep_control_data deepsleep_data[] = {
 	(RC5T583_EXT_PWRREQ1_CONTROL | RC5T583_EXT_PWRREQ2_CONTROL)
 
 static struct mfd_cell rc5t583_subdevs[] = {
+	{.name = "rc5t583-gpio",},
 	{.name = "rc5t583-regulator",},
 	{.name = "rc5t583-rtc",      },
 	{.name = "rc5t583-key",      }
-- 
1.7.1.1

