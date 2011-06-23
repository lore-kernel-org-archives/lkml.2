Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab1FWQqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:46:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54521 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384Ab1FWQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AIvlkddI7ZDV3lsCpsq5Ve3sPdC64nzbrYZdjxkA9eixW2TQpbkW750jpW/sQyi+Ag
         I7azkeJ3YDUZJVRHoECo3RcL4APsDk4epKL9qBWQv1tBCp04/aHO36ME93q9xTz7Xypy
         TGLGn1kLeyHxcuTtsFVe6m31TP9AJW1FhHl0Q=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf script: Rename old perf-trace to perf-script
Date: Fri, 24 Jun 2011 01:46:02 +0900
Message-Id: <1308847562-5100-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the leftovers from commit 133dc4c39c57 ("perf: Rename
'perf trace' to 'perf script'").

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/Documentation/perf-probe.txt            |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 02bafce4b341..41343d693f35 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -183,4 +183,4 @@ Delete all probes on schedule().
 
 SEE ALSO
 --------
-linkperf:perf-trace[1], linkperf:perf-record[1]
+linkperf:perf-script[1], linkperf:perf-record[1]
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 6ccf70e8d8f2..8173636c9817 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -465,7 +465,7 @@ static int python_generate_script(const char *outfile)
 	fprintf(ofp, "# be retrieved using Python functions of the form "
 		"common_*(context).\n");
 
-	fprintf(ofp, "# See the perf-trace-python Documentation for the list "
+	fprintf(ofp, "# See the perf-script-python Documentation for the list "
 		"of available functions.\n\n");
 
 	fprintf(ofp, "import os\n");
-- 
1.7.5.2

