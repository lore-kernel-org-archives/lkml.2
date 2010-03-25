Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0CYRXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:33 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0CYRXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kiidS+4jm2yrWIEN6pk9LzzCE76YJvneBBF88GLXaDrf/PX6JJvbWUR8q+PM5/aJqz
         Ll1j1cEq9GkvU8l4DAsJqFjys5fBp2T4Yx+VDCHhxSC/bQVJo2Oy+0Q/+gV9kN6C9DcS
         vLveqbIaPzRsdrpZmq04G9VJ4BBHs8xF67F9I=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] Tools perf builtin-trace.c: duplicated includes
Date: Thu, 25 Mar 2010 18:22:43 +0100
Message-Id: <1269537767-7553-13-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tools/perf/builtin-trace.c: util/exec_cmd.h and util/trace-event.h are included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 tools/perf/builtin-trace.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 407041d..3c699c5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -59,9 +59,6 @@ static int cleanup_scripting(void)
 #include "perf.h"
 #include "util/debug.h"
 
-#include "util/trace-event.h"
-#include "util/exec_cmd.h"
-
 static char const		*input_name = "perf.data";
 
 static int process_sample_event(event_t *event, struct perf_session *session)
-- 
1.7.0.3.296.g9776a

