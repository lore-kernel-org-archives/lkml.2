Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2H0SWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:22:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2H0SWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:22:17 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0RydBfvECm4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=9zSq_SAaQk8A:10 a=meVymXHHAAAA:8 a=Sqv0NHpG3uGkbr7ceLsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: [PATCH] Add feature-removal-schedule.txt removal to
 feature-removal-schedule.txt
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Aug 2012 14:22:05 -0400
Message-ID: <1346091725.19381.10.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file feature-removal-schedule.txt is ignored by most people except
for people that add to it. It's more of a global TODO list for
developers than being anything useful by anyone.

Add a feature removal of removing the feature-removal-schedule.txt.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 Documentation/feature-removal-schedule.txt |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index afaff31..dcbb573 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,17 @@ be removed from this file.  The suggested deprecation period is 3 releases.
 
 ---------------------------
 
+What:	Documentation/feature-removal-schedule.txt
+When:	v3.8
+Why:	Developers add their TODO list here, and no one else reads it.
+	It causes a lot of silly conflicts that annoy Linus.
+	There are better ways to remove features than adding your crap here.
+	Add a printk() or 'CONFIG_FOO default n' and see who complains.
+	This file has been proven to be absolutely useless.
+Who:	Steven Rostedt <rostedt@goodmis.org>
+
+---------------------------
+
 What:	ddebug_query="query" boot cmdline param
 When:	v3.8
 Why:	obsoleted by dyndbg="query" and module.dyndbg="query"


