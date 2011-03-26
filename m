Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276Ab1CZBom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:44:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47054 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934225Ab1CZBok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:40 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18CB4sp0hkCb8aR3L7BSdBpgR9ID/cAT4WSrmnmRI
	KUKoRulBaq5iuR
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 20/27] staging/ste_rmi4: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:04 +0100
Message-Id: <1301103851-16352-20-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a spelling mistake in
drivers/staging/ste_rmi4.

WRONG -> RIGHT
wierd	-> weird

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index d55a8e4..f899809 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -561,7 +561,7 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
 	}
 	/*
 	 * 2D data sources have only 3 bits for the number of fingers
-	 * supported - so the encoding is a bit wierd.
+	 * supported - so the encoding is a bit weird.
 	 */
 	if ((queries[1] & MASK_3BIT) <= 4)
 		/* add 1 since zero based */
-- 
1.7.3.4

