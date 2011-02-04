Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1BDM6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:58:42 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56639 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1BDM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:58:41 -0500
X-AuditID: b753bd60-a274aba0000001d0-c6-4d4bf7fc7c54
X-AuditID: b753bd60-a274aba0000001d0-c6-4d4bf7fc7c54
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 0/4] Perf probe/kprobe-tracer update (support
	bitfield, etc)
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Fri, 04 Feb 2011 21:51:45 +0900
Message-ID: <20110204125145.9507.5169.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series enhances perf-probe and kprobe-tracer to support
accessing bitfield and extending command-line buffer.
I'm not sure which tree(-tip or -perf/core) I should push into
this series ... anyway, this can be applied both of them;-)

Thank you,

---

Masami Hiramatsu (4):
      perf/probe: Add bitfield member support
      tracing/kprobes: Add bitfield type
      tracing/kprobes: support longer(>128) command
      tracing/kprobes: Cleanup strict_strtol() using code


 Documentation/trace/kprobetrace.txt |   16 +++++
 kernel/trace/trace_kprobe.c         |  111 +++++++++++++++++++++++++++++++++--
 tools/perf/util/probe-finder.c      |   95 +++++++++++++++++++++---------
 3 files changed, 189 insertions(+), 33 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

