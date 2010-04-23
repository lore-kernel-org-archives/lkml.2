Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0DWUhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:37:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771Ab0DWUhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:37:00 -0400
Message-ID: <4BD204C5.9000504@redhat.com>
Date: Fri, 23 Apr 2010 16:36:21 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf-kvm.txt edits
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asciidoc does not allow the "===" to be longer than the line above it.
Also corrected a couple types and formatting errors.
Signed-off-by: William Cohen <wcohen@redhat.com>
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
1.6.6.1

