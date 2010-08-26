Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0HZOge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:36:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0HZOgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:36:32 -0400
Date: Thu, 26 Aug 2010 10:35:43 -0400
From: Jason Baron <jbaron@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        fweisbec@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] workqueue: Add basic tracepoints to track workqueue
	execution
Message-ID: <20100826143542.GA2947@redhat.com>
References: <20100821131402.577c4d75@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821131402.577c4d75@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 01:14:02PM -0700, Arjan van de Ven wrote:
> With the introduction of the new unified work queue thread pools,
> we lost one feature: It's no longer possible to know which worker
> is causing the CPU to wake out of idle. The result is that PowerTOP
> now reports a lot of "kworker/a:b" instead of more readable results.
> 
> This patch adds a pair of tracepoints to the new workqueue code,
> similar in style to the timer/hrtimer tracepoints.
> 

Hi,

it might also be nice to add a workqueue chapter to the traceopint docbook.
Since you've already included kernel-doc style comments, the below is all that
we need.

current book is at: http://www.kernel.org/doc/htmldocs/tracepoint/

thanks,

-Jason


Add a workqueue chapter to the tracepoint docbook

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 Documentation/DocBook/tracepoint.tmpl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
index e8473ea..b57a9ed 100644
--- a/Documentation/DocBook/tracepoint.tmpl
+++ b/Documentation/DocBook/tracepoint.tmpl
@@ -104,4 +104,9 @@
    <title>Block IO</title>
 !Iinclude/trace/events/block.h
   </chapter>
+
+  <chapter id="workqueue">
+   <title>Workqueue</title>
+!Iinclude/trace/events/workqueue.h
+  </chapter>
 </book>
-- 
1.6.0.6

