Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0DXCGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:06:38 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43965 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab0DXCFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=jTfyhmVvU8LvjZQy3UTfj8GDIAtw98VCerpjTnnhRpHQNbV/MQlsLggVrzD2bkYBHu
         n/DWOruLs8siMEKNL/0OpYhkOPESpCJKWuz2FyvqZ5TLpNofu4I8Rprzhegqm7WZAyr2
         6cl4+5y+HfLeZcjDmwF2HebBqpO4bkxGY4h5A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, William Cohen <wcohen@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 9/9] perf: Some perf-kvm documentation edits
Date: Sat, 24 Apr 2010 04:05:42 +0200
Message-Id: <1272074742-3654-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Cohen <wcohen@redhat.com>

asciidoc does not allow the "===" to be longer than the line
above it.
Also fix a couple types and formatting errors.

Signed-off-by: William Cohen <wcohen@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4BD204C5.9000504@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Documentation/perf-kvm.txt |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 93400a0..d004e19 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -1,5 +1,5 @@
 perf-kvm(1)
-==============
+===========
 
 NAME
 ----
@@ -41,9 +41,9 @@ There are a couple of variants of perf kvm:
 OPTIONS
 -------
 --host=::
-        Collect host side perforamnce profile.
+        Collect host side performance profile.
 --guest=::
-        Collect guest side perforamnce profile.
+        Collect guest side performance profile.
 --guestmount=<path>::
 	Guest os root file system mount directory. Users mounts guest os
         root directories under <path> by a specific filesystem access method,
@@ -64,4 +64,5 @@ OPTIONS
 
 SEE ALSO
 --------
-linkperf:perf-top[1] perf-record[1] perf-report[1] perf-diff[1] perf-buildid-list[1]
+linkperf:perf-top[1], linkperf:perf-record[1], linkperf:perf-report[1],
+linkperf:perf-diff[1], linkperf:perf-buildid-list[1]
-- 
1.6.2.3

