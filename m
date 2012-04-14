Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2DNJNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:13:20 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:41331 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2DNJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:13:00 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 2/2] sbp-target: update TODO file
Date: Sat, 14 Apr 2012 10:12:26 +0100
Message-Id: <1334394746-31738-3-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334394746-31738-1-git-send-email-bootc@bootc.net>
References: <1334394746-31738-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TODO wasn't updated after the last batch of changes before the
merge, so remove those items that have been completed. This patch also
re-orders the existing items in priority order and adds a new one.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/sbp/TODO |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/sbp/TODO b/drivers/target/sbp/TODO
index eaec1c9..e800058 100644
--- a/drivers/target/sbp/TODO
+++ b/drivers/target/sbp/TODO
@@ -1,7 +1,7 @@
-* Force-terminate sessions when disabling targets
+1. Improve FireWire data transfer rate by queuing up several simultaneous transfers
+2. Force-terminate sessions when disabling targets
+3. Implement TASK MANAGEMENT functionality
 * Ability to have several SCSI commands in-flight (TCQ?)
-* Retry failed FireWire transactions a few times with exponential backoff
-* Take into account the page_size field for transfers and/or page tables
+* Take into account the page_size field for transfers
 * Handle descriptor format sense data
 * Implement QUERY LOGINS management ORB
-* Implement TASK MANAGEMENT functionality
-- 
1.7.9.5

