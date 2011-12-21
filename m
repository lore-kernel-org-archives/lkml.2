Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1LUVtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:49:01 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53269 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752452Ab1LUVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:48:58 -0500
Date: Wed, 21 Dec 2011 16:48:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org
Subject: [PATCH] staging: Remove LTTng from MAINTAINERS file
Message-ID: <20111221214855.GA31795@Krystal>
References: <13233869223911@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13233869223911@kroah.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:41:12 up 393 days,  2:44,  6 users,  load average: 0.03, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng has been removed from the staging tree. Complete this removal by
removing the LTTng entry from the MAINTAINERS file.
    
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index f3bb825..1514f7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4132,13 +4132,6 @@ W:	http://ltp.sourceforge.net/
 T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
-LTTng (Linux Trace Toolkit Next Generation)
-M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
-L:	lttng-dev@lists.lttng.org (moderated for non-subscribers)
-W:	http://lttng.org
-S:	Maintained
-F:	drivers/staging/lttng/
-
 M32R ARCHITECTURE
 M:	Hirokazu Takata <takata@linux-m32r.org>
 L:	linux-m32r@ml.linux-m32r.org (moderated for non-subscribers)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
