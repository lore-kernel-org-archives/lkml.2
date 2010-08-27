Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0H0Kfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:35:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:46005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0H0Kft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:35:49 -0400
Message-ID: <4C779394.2000003@kernel.org>
Date: Fri, 27 Aug 2010 12:29:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH] workqueue: Add a workqueue chapter to the tracepoint docbook
References: <20100821131402.577c4d75@infradead.org> <20100826143542.GA2947@redhat.com>
In-Reply-To: <20100826143542.GA2947@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 10:35:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add a workqueue chapter to the traceopint docbook.

Current book is at: http://www.kernel.org/doc/htmldocs/tracepoint/

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied w/ patch description update.  Thanks.

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
1.7.1

