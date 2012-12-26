Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2LZCxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:53:18 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47203 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2LZCxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:53:14 -0500
X-AuditID: 85900ec0-d867eb900000152f-e8-50da669829a3
Subject: [PATCH v4 -tip 0/3] tracing: make a snapshot feature available from
 userspace
To: rostedt@goodmis.org
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 26 Dec 2012 11:52:43 +0900
Message-ID: <20121226025243.3252.61095.stgit@liselsia>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

I updated the patch which replaces static variable 'old_tracer'.

v3->v4:
 [1/3] tracing: replace static old_tracer with trace iterator's pointer to the
       original tracer's name
        - changed to comparison between pointers instead of strcmp

(v3: https://lkml.org/lkml/2012/12/19/35)

---

Hiraku Toyooka (3):
      tracing: replace static old_tracer with trace iterator's pointer to the original tracer's name
      tracing: make a snapshot feature available from userspace
      tracing: add description of snapshot to Documentation/trace/ftrace.txt


 Documentation/trace/ftrace.txt |   83 +++++++++++++++++++++
 include/linux/ftrace_event.h   |    3 +
 kernel/trace/Kconfig           |   10 +++
 kernel/trace/trace.c           |  156 ++++++++++++++++++++++++++++++++++------
 kernel/trace/trace.h           |    1 
 5 files changed, 228 insertions(+), 25 deletions(-)

-- 
Hiraku TOYOOKA
Linux Technology Center
Yokohama Research Laboratory
Hitachi Ltd.
