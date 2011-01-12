Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1ALIAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:00:54 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:58557 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab1ALIAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:00:53 -0500
Date: Wed, 12 Jan 2011 03:00:46 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        arjan@linux.intel.com, j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SH, cpuidle: delete use of NOP CPUIDLE_FLAGS_SHALLOW
In-reply-to: <alpine.LFD.2.02.1101120235390.19140@x980>
Message-id: <alpine.LFD.2.02.1101120258550.19140@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-6-git-send-email-trenn@suse.de>
 <alpine.LFD.2.02.1101120159400.19140@x980>
 <alpine.LFD.2.02.1101120229060.19140@x980>
 <alpine.LFD.2.02.1101120235390.19140@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

set but not checked.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/sh/kernel/cpu/shmobile/cpuidle.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
index 83972aa..c19e2a9 100644
--- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
+++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
@@ -81,7 +81,6 @@ void sh_mobile_setup_cpuidle(void)
 	state->target_residency = 1 * 2;
 	state->power_usage = 3;
 	state->flags = 0;
-	state->flags |= CPUIDLE_FLAG_SHALLOW;
 	state->flags |= CPUIDLE_FLAG_TIME_VALID;
 	state->enter = cpuidle_sleep_enter;
 
-- 
1.7.4.rc1.7.g2cf08


