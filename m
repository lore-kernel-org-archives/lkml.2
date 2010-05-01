Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0EAAeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:34:20 -0400
Received: from ozlabs.org ([203.10.76.45]:35788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab0EAAeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:34:15 -0400
Date: Sat, 1 May 2010 10:28:11 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Kosina <jkosina@suse.cz>, Tejun Heo <tj@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_event: Use UTF-8 copyright symbol instead of \251
Message-ID: <20100501002811.GA2610@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted by Tejun Heo, the latin-1 copyright character \251 is invalid
in ASCII or UTF-8.  This changes the character to its UTF-8 encoding
in order to avoid problems with editors and other tools.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9dbe8cd..d46a277 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
- *  Copyright  �  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
  */
