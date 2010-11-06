Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0KFQZF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:25:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52739 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0KFQZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vrxRijODXVwIX6xvcBl1AMbRlJVxGJPivr0Oe/mrS0wNgJeSoYiHrz8dNkIgapZEY3
         qYJ4iFR7+GWdHjRQ09Hhzoi3AEQ8spmVXNygahRM2zji8pituej9vZuSjVG82D/PL3GW
         YQ32lKhUWdt2/nlJESB77V912pYBk421/mls4=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de, greg@kroah.com, johanmeiring@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, sjakub@gmail.com
Subject: [PATCH 6/6] Staging: asus_oled: fix coding style issue in asus_oled.c
Date: Sat,  6 Nov 2010 18:24:46 +0200
Message-Id: <1289060686-13904-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the asus_oled.c file that fixes up brace and enum warning found by the checkpatch.pl tool

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/asus_oled/asus_oled.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 8c95d8c..1dda9fb 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -70,7 +70,7 @@ module_param(start_off, uint, 0644);
 MODULE_PARM_DESC(start_off,
 		 "Set to 1 to switch off OLED display after it is attached");
 
-enum oled_pack_mode{
+enum oled_pack_mode {
 	PACK_MODE_G1,
 	PACK_MODE_G50,
 	PACK_MODE_LAST
-- 
1.7.1

