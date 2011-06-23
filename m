Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab1FWRo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:44:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:35605 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825Ab1FWRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Roman Fietze <roman.fietze@telemotive.de>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 201/247] i2c: Fix typo in instantiating-devices document
Date: Thu, 23 Jun 2011 13:34:29 -0400
Message-Id: <1308850515-15242-142-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Fietze <roman.fietze@telemotive.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6ced9e6b3901af4ab6ac0a11231402c888286ea6 upstream.

The struct i2c_board_info member holding the name is "type", not
"name".

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/i2c/instantiating-devices |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/instantiating-devices
index e894902..ed1779c 100644
--- a/Documentation/i2c/instantiating-devices
+++ b/Documentation/i2c/instantiating-devices
@@ -100,7 +100,7 @@ static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
 	(...)
 	i2c_adap = i2c_get_adapter(2);
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
+	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
 						   normal_i2c);
 	i2c_put_adapter(i2c_adap);
-- 
1.7.4.4

