Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0EGSkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:40:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:59581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab0EGSkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:40:12 -0400
Date: Fri, 7 May 2010 18:39:47 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <4B2F154C.2060503@cn.fujitsu.com>
References: <4B2F154C.2060503@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Make the documentation clear on trace_event boot option
Message-ID: <tip-03d646e62b06e9364e2dbb939d67934c6c9826cd@git.kernel.org>
Git-Commit-ID: 03d646e62b06e9364e2dbb939d67934c6c9826cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:39:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03d646e62b06e9364e2dbb939d67934c6c9826cd
Gitweb:     http://git.kernel.org/tip/03d646e62b06e9364e2dbb939d67934c6c9826cd
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 21 Dec 2009 14:27:24 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 4 May 2010 16:25:51 -0400

tracing: Make the documentation clear on trace_event boot option

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
