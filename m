Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0HOFWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:22:23 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:64845 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0HOFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:22:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 5/5] intel_idle: recognize Lincroft Atom Processor
Date: Sun, 15 Aug 2010 01:22:05 -0400
Message-id: <4725fd3ce970c27a1678fb0809bfc7c2f4ac3e4f.1281849655.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.2.1.95.g3d045
In-reply-to: <1281849725-7379-1-git-send-email-lenb@kernel.org>
References: <1281849725-7379-1-git-send-email-lenb@kernel.org>
In-reply-to: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
References: <0394c6676e3fa48587fbe4821390d3264672c530.1281849655.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 97655ed..b1909fb 100755
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -265,6 +265,7 @@ static int intel_idle_probe(void)
 		break;
 
 	case 0x1C:	/* 28 - Atom Processor */
+	case 0x26:	/* 38 - Lincroft Atom Processor */
 		lapic_timer_reliable_states = (1 << 2) | (1 << 1); /* C2, C1 */
 		cpuidle_state_table = atom_cstates;
 		break;
-- 
1.7.2.1.95.g3d045

