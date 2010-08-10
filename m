Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0HJPrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:47:51 -0400
Received: from imr4.ericy.com ([198.24.6.8]:36717 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab0HJPrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:47:46 -0400
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2010 11:47:45 EDT
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] power: Remove owner field from attribute initialization code in OLPC driver
Date: Tue, 10 Aug 2010 08:21:50 -0700
Message-ID: <1281453710-31573-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/power/olpc_battery.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index baefcf1..5ab9109 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -384,7 +384,6 @@ static struct bin_attribute olpc_bat_eeprom = {
 	.attr = {
 		.name = "eeprom",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = 0,
 	.read = olpc_bat_eeprom_read,
-- 
1.7.0.87.g0901d

