Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0KIVSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:18:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35283 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab0KIVSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:18:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NP3zvIOCJtTJAUXo3BIyjHuddagEYfZ9BRj7AFL44LGFzOCysvtqGjzgCJjw2PDjFQ
         ULhn3UGaFRwVn25Y8VIf520j6e2Vo8lSxU1kJmiZjclOV/2dK7bcQeRaaRldD5TsQWhq
         xBbuvHoAJfPuGQ1KnX0QDhAii1IsPfgi911Qc=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 7/7] perf trace: update usage
Date: Tue,  9 Nov 2010 15:18:22 -0600
Message-Id: <1289337502-2492-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
References: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Update usage to reflect the different perf trace variants.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 tools/perf/builtin-trace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0483e28..86cfe38 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -570,7 +570,11 @@ out:
 }
 
 static const char * const trace_usage[] = {
-	"perf trace [<options>] <command>",
+	"perf trace [<options>]",
+	"perf trace [<options>] record <script> [<record-options>] <command>",
+	"perf trace [<options>] report <script> [script-args]",
+	"perf trace [<options>] <script> [<record-options>] <command>",
+	"perf trace [<options>] <top-script> [script-args]",
 	NULL
 };
 
-- 
Tom Zanussi, Intel Open Source Technology Center

