Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1GYP0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:26:48 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:47509 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab1GYPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4E2D8993.3070607@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:19:47 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Malte Starostik <m-starostik@versanet.de>,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 05/10] hp_accel: Add HP ProBook 655x
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add axis correction for HP ProBook 6555b.

Signed-off-by: Malte Starostik <m-starostik@versanet.de>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/platform/x86/hp_accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 626b162..89c5cb5 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -229,6 +229,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("HPB452x", "HP ProBook 452", y_inverted),
 	AXIS_DMI_MATCH("HPB522x", "HP ProBook 522", xy_swap),
 	AXIS_DMI_MATCH("HPB532x", "HP ProBook 532", y_inverted),
+	AXIS_DMI_MATCH("HPB655x", "HP ProBook 655", xy_swap_inverted),
 	AXIS_DMI_MATCH("Mini510x", "HP Mini 510", xy_rotated_left_usd),
 	{ NULL, }
 /* Laptop models without axis info (yet):
-- 
1.7.6

