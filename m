Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab1KJGTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:19:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51430 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1KJGTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:19:19 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Thu, 10 Nov 2011 15:19:18 +0900
X-Google-Sender-Auth: x0RHha95iXPsyaaWoYwMcoWmnxc
Message-ID: <CAJ0PZbQxL3urqi06xefcYwvAn=P2FDMR3YW0LVRySmnchQ+UUQ@mail.gmail.com>
Subject: [PATCH] Devfreq/core: remove compiler error after irq.h update
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "Hilman, Kevin" <khilman@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added <linux/module.h> and <linux/stat.h> to avoid a compiler error
because linux/irq.h no longer includes linux/module.h after Linux 3.2.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/devfreq/devfreq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 2355543..7b9d4b5 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -15,7 +15,9 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/stat.h>
 #include <linux/opp.h>
 #include <linux/devfreq.h>
 #include <linux/workqueue.h>
-- 
1.7.4.1
