Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0HOFWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:22:15 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:48983 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0HOFWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:22:12 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/5] intel_idle: add support for Westmere-EX
Date: Sun, 15 Aug 2010 01:22:02 -0400
Message-id: <ec67a2ba360d4874b1158e6e87fe1e859b0c9117.1281849655.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.2.1.95.g3d045
In-reply-to: <1281849725-7379-1-git-send-email-lenb@kernel.org>
References: <1281849725-7379-1-git-send-email-lenb@kernel.org>
In-reply-to: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
References: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 6d43bc3..97655ed 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -256,6 +256,7 @@ static int intel_idle_probe(void)
 	case 0x1E:	/* Core i7 and i5 Processor - Lynnfield Jasper Forest */
 	case 0x1F:	/* Core i7 and i5 Processor - Nehalem */
 	case 0x2E:	/* Nehalem-EX Xeon */
+	case 0x2F:	/* Westmere-EX Xeon */
 		lapic_timer_reliable_states = (1 << 1);	 /* C1 */
 
 	case 0x25:	/* Westmere */
-- 
1.7.2.1.95.g3d045

