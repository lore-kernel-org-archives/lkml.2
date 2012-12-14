Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2LNN5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:57:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62845 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2LNN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:57:39 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@sisk.pl
Cc: jwerner@chromium.org, francescolavra.fl@gmail.com,
        linux-pm@vger.kernel.org, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, linaro-dev@lists.linaro.org, len.brown@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        snanda@chromium.org
Subject: [PATCH 0/2][V2] cpuidle - remove power from the select equation
Date: Fri, 14 Dec 2012 14:57:33 +0100
Message-Id: <1355493455-30665-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The states could be sorted in the power backward order, we get rid of
some lines of code and by this way that fixes also a bug in the dynamic
c-states.

Changelog:

V2:
 * added the optimization in the select menu governor

Daniel Lezcano (2):
  cpuidle - remove the power_specified field in the driver
  cpuidle - optimize the select function for the 'menu' governor

 drivers/cpuidle/cpuidle.c        |   17 ++++-------------
 drivers/cpuidle/driver.c         |   25 -------------------------
 drivers/cpuidle/governors/menu.c |   20 ++++++++------------
 include/linux/cpuidle.h          |    2 +-
 4 files changed, 13 insertions(+), 51 deletions(-)

-- 
1.7.5.4

