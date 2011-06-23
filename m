Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422Ab1FWUez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:34:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65198 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab1FWUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:34:52 -0400
From: Eric B Munson <emunson@mgebm.net>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 1/3] events: Add note to update_event_times comment about holding ctx->lock
Date: Thu, 23 Jun 2011 16:34:37 -0400
Message-Id: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 kernel/events/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..a054964 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -731,6 +731,7 @@ static u64 perf_event_time(struct perf_event *event)
 
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
+ * The caller of this function needs to hold the ctx->lock.
  */
 static void update_event_times(struct perf_event *event)
 {
-- 
1.7.4.1

