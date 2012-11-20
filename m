Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2KTF3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:29:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32908 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2KTF3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:29:00 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 2/7] extcon: max8997: Fix a typo
Date: Tue, 20 Nov 2012 10:52:38 +0530
Message-Id: <1353388963-23761-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Electrnoics -> Electronics

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index c364794..af8a5bc 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -1,7 +1,7 @@
 /*
  * extcon-max8997.c - MAX8997 extcon driver to support MAX8997 MUIC
  *
- *  Copyright (C) 2012 Samsung Electrnoics
+ *  Copyright (C) 2012 Samsung Electronics
  *  Donggeun Kim <dg77.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.4.1

