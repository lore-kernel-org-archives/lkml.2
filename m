Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1GYPYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:24:50 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:60723 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1GYPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:42 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4E2D8937.3050807@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:18:15 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Witold Pilat <witold.pilat@gmail.com>
Subject: [PATCH 03/10] lis3: add support for HP EliteBook 2730p
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add axis correction for HP EliteBook 2730p.

Tested-by: Witold Pilat <witold.pilat@gmail.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/platform/x86/hp_accel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 891e71f..76b24e6 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -209,6 +209,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
+	AXIS_DMI_MATCH("NC273xx", "HP EliteBook 273", y_inverted),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
 			PRODUCT_NAME, "HP Pavilion dv5",
-- 
1.7.6

