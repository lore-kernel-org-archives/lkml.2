Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab2ILClr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 22:41:47 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:54743 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2ILClp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 22:41:45 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 0/3] TSC trace_clock
Date: Tue, 11 Sep 2012 19:41:08 -0700
Message-Id: <1347417671-22998-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at Plumbers, here are my patches to add a TSC clock to ftrace.
Also noticeable is that the formatting patch improves the output of the
"counter" clock.

David Sharp (3):
  tracing,x86: add a TSC trace_clock; reset buffer on clock change
  tracing: reset ring buffer when changing trace_clocks
  tracing: format non-nanosec times from tsc clock without a decimal
    point.

 include/linux/ftrace_event.h |    6 +++
 include/linux/trace_clock.h  |    3 ++
 kernel/trace/trace.c         |   26 ++++++++++++--
 kernel/trace/trace.h         |    4 --
 kernel/trace/trace_clock.c   |   16 ++++++++
 kernel/trace/trace_output.c  |   82 +++++++++++++++++++++++++++++-------------
 6 files changed, 105 insertions(+), 32 deletions(-)

-- 
1.7.7.3

