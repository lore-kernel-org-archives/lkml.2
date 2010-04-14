Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0DNWaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:30:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0DNWaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:30:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/6] perf-probe bugfixes
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 14 Apr 2010 18:36:52 -0400
Message-ID: <20100414223652.14224.28067.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Could you pull these patches into your tree too?
These fixes several bugs on perf probe.

Thank you,

---

Masami Hiramatsu (6):
      perf probe: Show function entry line as probe-able
      perf probe: Support DW_OP_plus_uconst in DW_AT_data_member_location
      perf probe: Fix line range to show end line
      perf probe: Fix a bug that --line range can be overflow
      perf probe: Fix mis-estimation for shortening filename
      perf probe: Fix to use correct debugfs path finder


 tools/perf/builtin-probe.c     |    4 -
 tools/perf/util/probe-event.c  |   51 ++++++++++------
 tools/perf/util/probe-event.h  |    6 +-
 tools/perf/util/probe-finder.c |  128 ++++++++++++++++++++++++++++++++--------
 4 files changed, 139 insertions(+), 50 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
