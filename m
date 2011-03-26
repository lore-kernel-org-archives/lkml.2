Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab1CZBpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:45:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46944 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932219Ab1CZBoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:38 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+IZVtUs+OI7b8DcqnXjEetZt89sNcMDYSZ84W5Lo
	4fF7v/VicQP5k0
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 18/27] staging/sep: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:02 +0100
Message-Id: <1301103851-16352-18-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/sep.

WRONG -> RIGHT
occured     -> occurred

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/sep/sep_driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 71a5fbc..0277911 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -586,7 +586,7 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
 		sep->send_ct, sep->reply_ct);
 
-	/* Check if error occured during poll */
+	/* Check if error occurred during poll */
 	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	if (retval2 != 0x0) {
 		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
-- 
1.7.3.4

