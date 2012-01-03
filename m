Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab2ACURM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:17:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2ACUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:16:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf kvm: Fix copy & paste error in description
Date: Tue,  3 Jan 2012 18:16:24 -0200
Message-Id: <1325621784-10683-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1325621784-10683-1-git-send-email-acme@infradead.org>
References: <1325621784-10683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The --host option certainly enables host-data collection.

Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: kvm@vger.kernel.org
Link: http://lkml.kernel.org/r/1317816084-18026-5-git-send-email-gleb@redhat.com
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.8.rc0.35.gee6df

