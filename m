Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1AMMvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:51:24 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39099 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1AMMvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:51:23 -0500
X-AuditID: b753bd60-9d951ba00000044b-27-4d2ef546625e
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 0/6] Perf probe update (support inline
	call-site/--funcs/--filter)
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Date: Thu, 13 Jan 2011 21:45:48 +0900
Message-ID: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series enhances line-finder to find inline-function
call site, and adds two features; showing available
functions (Originally came from Srikar's uprobe series)
and function/variable filtering support.

Thank you,

---

Masami Hiramatsu (6):
      perf probe: Add filters support for available functions
      perf probe: Add variable filter support
      perf: Add strfilter for general purpose string filter
      perf probe: Add --funcs to show available functions in symtab
      perf probe: Enable to put probe inline function call site
      perf probe: Introduce lines walker interface


 tools/perf/Documentation/perf-probe.txt |   15 +
 tools/perf/Makefile                     |    2 
 tools/perf/builtin-probe.c              |   70 ++++++
 tools/perf/util/probe-event.c           |  137 +++++++++---
 tools/perf/util/probe-event.h           |    4 
 tools/perf/util/probe-finder.c          |  361 ++++++++++++++++++-------------
 tools/perf/util/strfilter.c             |  185 ++++++++++++++++
 tools/perf/util/strfilter.h             |   36 +++
 8 files changed, 626 insertions(+), 184 deletions(-)
 create mode 100644 tools/perf/util/strfilter.c
 create mode 100644 tools/perf/util/strfilter.h

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

