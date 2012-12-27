Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2L0O4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:56:23 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57674 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2L0O4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:56:21 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v6 0/5] cpufreq: handle SW coordinated CPUs
Date: Thu, 27 Dec 2012 15:55:37 +0100
Message-Id: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

this is the v6 for the cpufreq SW coordinated CPU bug fix, that I was
holding for -rc1 as agreed.

Differences from v5:
- removed dangling special case in dbs_timer_init
- rebased on top of v3.8-rc1

Would you consider this set for -next?

Thanks,
Fabio


Fabio Baltieri (4):
  cpufreq: star/stop cpufreq timers on cpu hotplug
  cpufreq: ondemand: call dbs_check_cpu only when necessary
  cpufreq: conservative: call dbs_check_cpu only when necessary
  cpufreq: ondemand: use all CPUs in update_sampling_rate

Rickard Andersson (1):
  cpufreq: handle SW coordinated CPUs

 drivers/cpufreq/cpufreq_conservative.c | 46 ++++++++++++++--
 drivers/cpufreq/cpufreq_governor.c     | 98 +++++++++++++++++++++++++++++++---
 drivers/cpufreq/cpufreq_governor.h     |  2 +
 drivers/cpufreq/cpufreq_ondemand.c     | 62 ++++++++++++++++-----
 4 files changed, 185 insertions(+), 23 deletions(-)

-- 
1.7.12.1

