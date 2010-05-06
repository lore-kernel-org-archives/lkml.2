Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0EFXGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:06:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab0EFXF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:05:57 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=Eo7lU0EhZv0A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=8R75xTWvjpC4E_W9rBsA:9 a=C6zd1rKbTuEcdJinXtyWzTlGNckA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100506230459.278936703@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 06 May 2010 19:04:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Li Zefan (1):
      tracing: Make the documentation clear on trace_event boot option

Steven Rostedt (1):
      tracing: Fix tracepoint.h DECLARE_TRACE() to allow more than one header

Thiago Farina (1):
      tracing: Fix "integer as NULL pointer" warning.

----
 Documentation/trace/events.txt |    3 +-
 include/linux/tracepoint.h     |  114 +++++++++++++++++++++-------------------
 include/trace/define_trace.h   |    5 ++
 include/trace/events/napi.h    |   10 +++-
 kernel/trace/trace_output.c    |    2 +-
 5 files changed, 75 insertions(+), 59 deletions(-)
