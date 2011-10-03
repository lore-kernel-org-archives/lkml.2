Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1JCNvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1JCNum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:50:42 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH 4/9] perf, tools: Fix copy&paste error in perf-kvm option description
Date: Mon,  3 Oct 2011 15:49:50 +0200
Message-Id: <1317649795-18259-5-git-send-email-gleb@redhat.com>
In-Reply-To: <1317649795-18259-1-git-send-email-gleb@redhat.com>
References: <1317649795-18259-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The --host option certainly enables host-data collection.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 tools/perf/builtin-kvm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 34d1e85..032324a 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -38,7 +38,7 @@ static const struct option kvm_options[] = {
 	OPT_BOOLEAN(0, "guest", &perf_guest,
 		    "Collect guest os data"),
 	OPT_BOOLEAN(0, "host", &perf_host,
-		    "Collect guest os data"),
+		    "Collect host os data"),
 	OPT_STRING(0, "guestmount", &symbol_conf.guestmount, "directory",
 		   "guest mount directory under which every guest os"
 		   " instance has a subdir"),
-- 
1.7.5.3

