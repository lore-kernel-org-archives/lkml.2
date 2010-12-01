Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0LACBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:01:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0LAB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QPlobSyi07a8+aZFZSdFA2UHxLAYiwoj637I5VYD1z7TSaK5BDJkFfRskTSRzRnd1F
         P9z62QefWEDwbS/J5LErmr4VlhosH3otew+56UgO6wZeXVkQoFru2vpr7f0Jcz26hvXf
         NodgJYzLHCIq0FpVuI9ylhayKY+SPrZ/CiBfY=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 04/14] perf: Document missing diff options
Date: Tue, 30 Nov 2010 19:57:12 -0600
Message-Id: <1291168642-11402-5-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-diff.txt |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 20d97d8..6a9ec2b 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -19,6 +19,18 @@ If no parameters are passed it will assume perf.data.old and perf.data.
 
 OPTIONS
 -------
+-M::
+--displacement::
+        Show position displacement relative to baseline.
+
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
+-m::
+--modules::
+        Load module symbols. WARNING: use only with -k and LIVE kernel
+
 -d::
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
@@ -42,7 +54,7 @@ OPTIONS
 --field-separator=::
 
 	Use a special separator character and don't pad with spaces, replacing
-	all occurances of this separator in symbol names (and other output)
+	all occurrences of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
 
 -v::
@@ -50,6 +62,11 @@ OPTIONS
 	Be verbose, for instance, show the raw counts in addition to the
 	diff.
 
+-f::
+--force::
+       Don't complain, do it.
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
-- 
1.7.3.2

