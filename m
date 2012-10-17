Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2JQO3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:29:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab2JQO3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:29:02 -0400
From: Sangho Yi <antiroot@gmail.com>
To: broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH] extcon: extcon-arizona.c: fixed a line exceeding 80 chars
Date: Wed, 17 Oct 2012 23:27:09 +0900
Message-Id: <1350484030-3331-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a line exceeding 80 characters

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/extcon/extcon-arizona.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index cdab9e5..806c300 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -248,8 +248,8 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
 				if (lvl & arizona_lvl_to_key[i].status)
 					input_report_key(info->input,
-							 arizona_lvl_to_key[i].report,
-							 1);
+						arizona_lvl_to_key[i].report,
+						1);
 			input_sync(info->input);
 
 		} else if (info->detecting) {
-- 
1.7.9.5

