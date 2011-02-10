Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1BJJPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:15:17 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57979 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1BJJPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:15:15 -0500
X-AuditID: b753bd60-a6350ba0000001d0-ac-4d53aca08eab
X-AuditID: b753bd60-a6350ba0000001d0-ac-4d53aca08eab
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Date: Thu, 10 Feb 2011 18:07:56 +0900
Message-ID: <20110210090754.1809.36678.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH -perf/perf/core  0/2] Perf probe update for show-line option

Hi,

These patches update perf-probe to enhance
show-lines option (--line). 2nd patch has been
sent by Franck Bui-Huu. I've tweaked it a bit to
fit for current usage.

Thank you,

---

Masami Hiramatsu (2):
      perf probe: Show filename which contains target function
      perf probe: Support function@filename syntax for --line


 tools/perf/Documentation/perf-probe.txt |    7 ++++---
 tools/perf/util/probe-event.c           |   17 +++++++++++++----
 2 files changed, 17 insertions(+), 7 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

