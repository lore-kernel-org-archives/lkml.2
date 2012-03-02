Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab2CBA4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:56:16 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab2CBAzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:55:24 -0500
From: Richard Weinberger <richard@nod.at>
To: jonas@southpole.se
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/5] OpenRISC: Include export.h
Date: Fri,  2 Mar 2012 01:55:14 +0100
Message-Id: <1330649715-32438-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330649715-32438-1-git-send-email-richard@nod.at>
References: <1330649715-32438-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL* needs export.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/init_task.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/openrisc/kernel/init_task.c b/arch/openrisc/kernel/init_task.c
index 45744a38..70381d4 100644
--- a/arch/openrisc/kernel/init_task.c
+++ b/arch/openrisc/kernel/init_task.c
@@ -15,6 +15,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#include <linux/export.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
 
-- 
1.7.7.3

