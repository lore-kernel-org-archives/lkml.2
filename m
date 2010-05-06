Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0EFXGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:06:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0EFXF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:05:57 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=FtXDY24tHzUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=ZQalXS6dpfcPGRtfOdQA:9 a=hIMOYMEytsCICw-UOIoYSSydbikA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100506230555.125558106@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 06 May 2010 19:05:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/3] tracing: Make the documentation clear on trace_event boot option
References: <20100506230459.278936703@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Make-the-documentation-clear-on-trace_event-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Make it clear that event-list is a comma separated list of events.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B2F154C.2060503@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/events.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 02ac6ed..778ddf3 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -90,7 +90,8 @@ In order to facilitate early boot debugging, use boot option:
 
 	trace_event=[event-list]
 
-The format of this boot option is the same as described in section 2.1.
+event-list is a comma separated list of events. See section 2.1 for event
+format.
 
 3. Defining an event-enabled tracepoint
 =======================================
-- 
1.7.0


