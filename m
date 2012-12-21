Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2LUIU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:20:29 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62916 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2LUIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:20:21 -0500
X-AuditID: 9c930197-b7c5bae000000e31-af-50d41bc21a2c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 0/6] perf annotate: Add support for GTK+ annotation browser (v1)
Date: Fri, 21 Dec 2012 17:20:12 +0900
Message-Id: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds support to GTK+ annotation browser.  For now only
the first symbol gets sampled mostly per evsel will be shown.  IOW it shows 
the hottest symbol per evsel by default and you can change it by giving
the --symbol option or an argument.

Thanks,
Namhyung


Namhyung Kim (6):
  perf ui/gtk: Factor out common browser routines
  perf ui/gtk: Setup browser window early
  perf ui/gtk: Implement basic GTK2 annotation browser
  perf gtk/annotate: Support multiple annotation result
  perf gtk/annotate: Show source lines with gray color
  perf annotate: Add --gtk option

 tools/perf/Documentation/perf-annotate.txt |   4 +
 tools/perf/Makefile                        |   2 +
 tools/perf/builtin-annotate.c              |  14 +-
 tools/perf/ui/gtk/annotate.c               | 227 +++++++++++++++++++++++++++++
 tools/perf/ui/gtk/browser.c                | 227 +----------------------------
 tools/perf/ui/gtk/gtk.h                    |  10 +-
 tools/perf/ui/gtk/hists.c                  | 226 ++++++++++++++++++++++++++++
 tools/perf/util/annotate.h                 |  24 +++
 8 files changed, 509 insertions(+), 225 deletions(-)
 create mode 100644 tools/perf/ui/gtk/annotate.c
 create mode 100644 tools/perf/ui/gtk/hists.c

-- 
1.7.11.7

