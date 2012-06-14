Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2FNRfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:35:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45923 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2FNRfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:35:44 -0400
From: David Ahern <dsahern@gmail.com>
To: rostedt@goodmis.org, acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        weisbec@gmail.com
Cc: namhyung.kim@lge.com, mingo@kernel.org, peterz@infradead.org,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd plugins
Date: Thu, 14 Jun 2012 11:35:31 -0600
Message-Id: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that perf is using libtraceevent and libtraceevent is based
on trace-cmd both can be extended to leverage the plugins written
for trace-cmd to improve pretty printing of the events.

Given that it is based on code from trace-cmd I am not sure what the
right approach is, so wanted to throw this out for comments/suggestions.

David Ahern (2):
  libtraceevent: Add support for tracecmd plugins
  perf: add support for trace-cmd plugins

 tools/lib/traceevent/Makefile           |    2 +-
 tools/lib/traceevent/tracecmd-plugins.c |  280 +++++++++++++++++++++++++++++++
 tools/lib/traceevent/tracecmd-plugins.h |   34 ++++
 tools/perf/util/trace-event-parse.c     |    4 +
 4 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/tracecmd-plugins.c
 create mode 100644 tools/lib/traceevent/tracecmd-plugins.h

-- 
1.7.10.1

