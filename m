Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab1KWIPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:15:00 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:33701 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab1KWIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:14:59 -0500
From: jhbird.choi@samsung.com
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] max8997_charger: Remove duplicate module.h
Date: Wed, 23 Nov 2011 13:40:05 +0900
Message-Id: <1322023205-13904-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

module.h was included twice.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/power/max8997_charger.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index a23317d..ffc5033 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -19,7 +19,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-- 
1.7.1

