Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1B1G31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:29:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54147 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1B1G30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ua3wYZ7peZO75DKc36PeHc0ngkvpEr2IaLEzWV0LkOiDdYheHANV1H/Doty7112iBm
         bCpUN1Rl83yKlirfkdsAYaRoaYsnwkkRccYYe+h8nMsK1CWDeWEuO3DUU19T1vuJfx8X
         PsIyBmWRjw7g56y7NYqhLFUPSYAyaPhlssHhk=
Subject: [PATCH 2/3] mfd: pcf50633-core: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1298874735.5562.3.camel@mola>
References: <1298874735.5562.3.camel@mola>
Content-Type: text/plain
Date: Mon, 28 Feb 2011 14:33:12 +0800
Message-Id: <1298874792.5562.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding the MODULE_DEVICE_TABLE, below entries will be added to
modules.alias:
alias i2c:pcf50633 pcf50633

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 2640e4d..c1306ed 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -360,6 +360,7 @@ static struct i2c_device_id pcf50633_id_table[] = {
 	{"pcf50633", 0x73},
 	{/* end of list */}
 };
+MODULE_DEVICE_TABLE(i2c, pcf50633_id_table);
 
 static struct i2c_driver pcf50633_driver = {
 	.driver = {
-- 
1.7.2



