Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1CUWen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:34:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1CUWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:34:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=aJJESLkAynVGYPpPX9vEKn36cZC4QT7rCWba1JDAfR9yYvuVYDHDHnTVUJHXhNa+d
	LPMzR1EWwcEezQXAMwmGw==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH perf 0/2] perf: trace-event-parse: support more operators and print formats
Date: Mon, 21 Mar 2011 15:34:04 -0700
Message-Id: <1300746846-28245-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches correspond to similar patches recently applied to trace-cmd

[ Re-sending with more Cc's ]

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>


David Sharp (2):
  perf: trace-event-parse: support additional operators: '!', '~',  and
    '!='
  perf: trace-event-parse: support printing short fields

 tools/perf/util/trace-event-parse.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.3.1

