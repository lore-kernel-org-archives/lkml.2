Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab1DNSb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:31:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:37804 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab1DNRqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jean Delvare <khali@linux-fr.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 036/209] hwmon: (lm85) Fix ADT7468 frequency table
Date: Thu, 14 Apr 2011 13:41:06 -0400
Message-Id: <1302803039-9400-37-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit fa7a5797e57d2ed71f9a6fb44f0ae42c2d7b74b7 upstream.

The ADT7468 uses the same frequency table as the ADT7463.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/lm85.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index b3841a6..2e8f0c9 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1259,6 +1259,7 @@ static int lm85_probe(struct i2c_client *client,
 	switch (data->type) {
 	case adm1027:
 	case adt7463:
+	case adt7468:
 	case emc6d100:
 	case emc6d102:
 		data->freq_map = adm1027_freq_map;
-- 
1.7.4.4

