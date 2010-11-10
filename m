Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0KJSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:11:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45985 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab0KJSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HDjVyvONcsA8ZXJx1yaY1AA52Z+52GKiYU3bWQC9XHPUdT2U0u+Z6GCE0xkWGLqP3i
         GelD9gxykN9sP9H057oNEYI94mqlWJVorUe/eVl5litHhiVtKd3D4X+IU9FluUms28Xc
         Y2D1ebE4i+ubdd5QwqckYuvQoBcvz+ESLVZ/M=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 7/7] perf trace: update usage
Date: Wed, 10 Nov 2010 12:10:24 -0600
Message-Id: <1289412624-4772-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
References: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Update usage to reflect the different perf trace variants.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Acked-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/builtin-trace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0483e28..86cfe38 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -570,8 +570,11 @@ out:
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

