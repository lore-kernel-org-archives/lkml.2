Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0CYRYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:24:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35786 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0CYRXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=EkYTZXVdba7cC9MgVU+OvhXsvJB6ySuDxHpZ3pBtlHPo9/wXmTkQlA5BYhL/GOzB00
         86p5L/HJ9KsMJvv9wBJ9DU347jFxkl/kafBiTo06Asa3GQoWlER+8T5QY9xYSAWdwSQk
         rdbgo06k+kPa4spiz+zye6AXeX+9/RJK1Gy6Q=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] Tools perf probe-finder.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:44 +0100
Message-Id: <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tools/perf/util/probe-finder.c: string.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 tools/perf/util/probe-finder.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1e6c65e..682eb37 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -32,7 +32,6 @@
 #include <stdarg.h>
 #include <ctype.h>
 
-#include "string.h"
 #include "event.h"
 #include "debug.h"
 #include "util.h"
-- 
1.7.0.3.296.g9776a

