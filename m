Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0LAB7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:59:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36381 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0LAB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V2C5ZTp9vQlzoSzV3ILohMijlbtB1hOEYJLkcbJruLu5w1WThisKolrB9gBbJBCr8Q
         OI1LaT/MBA4WmnhAQ2T8P4/7rimu9dEX25vscoDw76Nf0IxcAkb5nakOexqyuGZ3Wmkw
         YjpV8re8AUdt4NCb/Izp4sc7wvPpPnbk+sMnI=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 14/14] perf: Document missing trace options
Date: Tue, 30 Nov 2010 19:57:22 -0600
Message-Id: <1291168642-11402-15-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-trace.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 26aff6b..1c61ea9 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -104,6 +104,13 @@ OPTIONS
         normally don't - this option allows the latter to be run in
         system-wide mode.
 
+-i::
+--input=::
+        Input file name.
+
+-d::
+--debug-mode::
+        Do various checks like samples ordering and lost events.
 
 SEE ALSO
 --------
-- 
1.7.3.2

