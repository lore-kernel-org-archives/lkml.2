Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1IYKqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 06:46:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1IYKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 06:46:33 -0400
Message-ID: <4E7F034C.7090609@gmail.com>
Date: Sun, 25 Sep 2011 16:02:44 +0530
From: Navin P <zicrim@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: marek.vasut@gmail.com, kernel-janitors@vger.kernel.org
Subject: [PATCH] Remove const keyword from matrix_keypad.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove the const keyword as SIMPLE_DEV_PMS_OPS already defines a const struct.
 Signed-off-by: Navin P <zicrim@gmail.com>

---
 drivers/input/keyboard/matrix_keypad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index b02e426..c127658 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -294,7 +294,7 @@ static int matrix_keypad_resume(struct device *dev)
 	return 0;
 }
 
-static const SIMPLE_DEV_PM_OPS(matrix_keypad_pm_ops,
+static SIMPLE_DEV_PM_OPS(matrix_keypad_pm_ops,
 				matrix_keypad_suspend, matrix_keypad_resume);
 #endif
 
-- 
1.7.0.4


