Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0LAB6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63977 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0LAB6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lRqWIPjszAvWbML+i6SD2qczfJubDYIyxQT2c7SC7Kcz8qeY7Mb3hEdL9JtDVetxPf
         +TVlYOWqcU50pqYb5eztYpg9Cq6ax5EgYB0oq/ejzwDznCfUhihSZGWWX4jYTugb8AxA
         SKWfbLqAPlQtgm9K0CNYMdWJIDCVAFZnJ6kuo=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 05/14] perf: Document missing kvm options
Date: Tue, 30 Nov 2010 19:57:13 -0600
Message-Id: <1291168642-11402-6-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-kvm.txt |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index d004e19..dd84cb2 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -22,7 +22,7 @@ There are a couple of variants of perf kvm:
   a performance counter profile of guest os in realtime
   of an arbitrary workload.
 
-  'perf kvm record <command>' to record the performance couinter profile
+  'perf kvm record <command>' to record the performance counter profile
   of an arbitrary workload and save it into a perf data file. If both
   --host and --guest are input, the perf data file name is perf.data.kvm.
   If there is  no --host but --guest, the file name is perf.data.guest.
@@ -40,6 +40,12 @@ There are a couple of variants of perf kvm:
 
 OPTIONS
 -------
+-i::
+--input=::
+        Input file name.
+-o::
+--output::
+        Output file name.
 --host=::
         Collect host side performance profile.
 --guest=::
-- 
1.7.3.2

