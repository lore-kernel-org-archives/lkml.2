Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0EIQml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:42:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45538 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0EIQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:42:36 -0400
From: Ritesh Raj Sarraf <rrs@debian.org>
To: robert.w.love@intel.com
Cc: linux-kernel@vger.kernel.org, Ritesh Raj Sarraf <rrs@researchut.com>,
       Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH] Add Lenovo Thinkpad T400 to the whitelist
Date: Sun,  9 May 2010 22:11:37 +0530
Message-Id: <1273423297-15731-1-git-send-email-rrs@debian.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ritesh Raj Sarraf <rrs@researchut.com>

Adding Lenovo Thinkpad T400, I have done the testing on my laptop.
The hdaps module detect the device and the hdapds daemon is able to
[un]park the disk.

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 drivers/hwmon/hdaps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index be2d131..bfd42f1 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -522,6 +522,7 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T400", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
-- 
1.7.1

