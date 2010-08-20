Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab0HTDDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:03:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:57607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0HTDDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:03:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,236,1280732400"; 
   d="scan'208";a="314847211"
Subject: [PATCH] lockup_detector: Make callback function static
From: Lin Ming <ming.m.lin@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 11:03:51 +0800
Message-ID: <1282273431.16443.32.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog_overflow_callback is only used in kernel/watchdog.c.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 613bc1f..b60e2a8 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -202,7 +202,7 @@ static struct perf_event_attr wd_hw_attr = {
 };
 
 /* Callback function for perf event subsystem */
-void watchdog_overflow_callback(struct perf_event *event, int nmi,
+static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
 {


