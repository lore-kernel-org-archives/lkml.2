Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2FFFyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:54:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52625 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2FFFyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:54:50 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] PM: devfreq: Add missing static storage class specifier in devfreq.c file
Date: Wed,  6 Jun 2012 11:13:46 +0530
Message-Id: <1338961426-31470-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warning:
drivers/devfreq/devfreq.c:30:14: warning: symbol 'devfreq_class' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/devfreq/devfreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 70c31d4..9eb6805 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -27,7 +27,7 @@
 #include <linux/hrtimer.h>
 #include "governor.h"
 
-struct class *devfreq_class;
+static struct class *devfreq_class;
 
 /*
  * devfreq_work periodically monitors every registered device.
-- 
1.7.4.1

