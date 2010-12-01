Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0LACBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:01:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0LAB6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QdpGTbyIUl14Lo4/qL7b/ZzEASeBS9LNhm0py4keUDCR8Ua9qSyDmnc3+4KjfShk28
         gQDi3z4pxmxbeElz+sAZ++h60FgiFPRygEEfgUtvqSsqiOWa8PPbwaR63s4CYwvMHnm3
         lDgQELjB2iSuOnNoOIq28pj32+fgp2v5vxLCI=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 02/14] perf: Document missing buildid-list options.
Date: Tue, 30 Nov 2010 19:57:10 -0600
Message-Id: <1291168642-11402-3-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-buildid-list.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index 01b642c..5eaac6f 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -18,6 +18,9 @@ perf report.
 
 OPTIONS
 -------
+-H::
+--with-hits::
+        Show only DSOs with hits.
 -i::
 --input=::
         Input file name. (default: perf.data)
-- 
1.7.3.2

