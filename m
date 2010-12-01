Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0LACAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:00:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0LAB6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vz0rMORfCxi+yYU5ziDfeeAaFzTJiNkkQDicJMb0NmqiO6wuFw6n8FVkTfqkUtfzns
         jE+OGcPvrgZurn8tggHYQEAgVRBWHW6ZlKzwdCUcneyxavJ8EbZdv8vXg1dlNovJqytC
         zAzDnSvg6TU+ev73Kti96oQdJef8BmZmLBdtE=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 06/14] perf: Document missing lock options
Date: Tue, 30 Nov 2010 19:57:14 -0600
Message-Id: <1291168642-11402-7-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-lock.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index b317102..921de25 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -24,6 +24,21 @@ and statistics with this 'perf lock' command.
 
   'perf lock report' reports statistical data.
 
+OPTIONS
+-------
+
+-i::
+--input=<file>::
+        Input file name.
+
+-v::
+--verbose::
+        Be more verbose (show symbol address, etc).
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
 SEE ALSO
 --------
 linkperf:perf[1]
-- 
1.7.3.2

