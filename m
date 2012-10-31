Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163Ab2J3SOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:14:23 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59058 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934108Ab2J3SMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:46 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] da8xx: Fix revision check on the da8xx driver
Date: Wed, 31 Oct 2012 17:56:24 +0200
Message-Id: <1351698984-4007-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The revision check fails for the beaglebone; Add new revision ID.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/video/da8xx-fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 80665f6..866d804 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -1283,6 +1283,7 @@ static int __devinit fb_probe(struct platform_device *device)
 		lcd_revision = LCD_VERSION_1;
 		break;
 	case 0x4F200800:
+	case 0x4F201000:
 		lcd_revision = LCD_VERSION_2;
 		break;
 	default:
-- 
1.7.12

