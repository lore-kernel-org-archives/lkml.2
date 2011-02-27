Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1B0Vgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:36:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1B0Vgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:36:49 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: trenn@suse.de, lenb@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Several riskless, tiny fixes
Date: Sun, 27 Feb 2011 22:36:41 +0100
Message-Id: <1298842606-55712-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these could still get pushed into 2.6.38?

If not, it would be great if they get queued in:
 - x86-tip tree, the two perf patches and the pm_qos patch
 - idle tree, the intel_idle patch
 - shmobile tree (which I expect exists), the shmobile patch

Thanks,

     Thomas

Thomas Renninger (5):
  shmobile: Rename cpuidle states to fit to general conventions
  intel_idle: Rename cpuidle states
  pm_qos: Make pm_qos settings readable
  perf: timechart: fix black idle boxes in the title.
  perf: timechart -> fix max number of cpus

 arch/sh/kernel/cpu/shmobile/cpuidle.c |    6 +++---
 drivers/idle/intel_idle.c             |   22 +++++++++++-----------
 kernel/pm_qos_params.c                |   24 ++++++++++++++++++++++++
 tools/perf/builtin-timechart.c        |    6 +++---
 tools/perf/util/svghelper.c           |    6 +++---
 5 files changed, 44 insertions(+), 20 deletions(-)

-- 
1.7.3.4

