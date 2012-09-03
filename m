Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2ICIUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:20:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:51049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab2ICIUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:20:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="scan'208";a="140902945"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 0/7] perf ui/browser: Add browser for perf script 
Date: Mon,  3 Sep 2012 16:14:26 +0800
Message-Id: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

This is a patch set mainly to add a browser for perf script, which
will be integrated into the main hists and annotation browser.

Patch 1-4 are some preparation for adding the script
patch 5 introduce the script browser
patch 6-7 integrate the browser to hists browser and annotation browser

The patches are on top of current perf/core branch of your git tree. 
Please help to review, thanks

Feng
-----------------------
Feng Tang (7):
  perf symbols: Filter samples with unresolved symbol when "--symbols"
    option is used
  perf scripts: Add --symbols option to handle specific symbols
  perf scripts: Add event_analyzing_sample-record/report
  perf scripts: Export a find_scripts() function
  perf ui/browser: Add a browser for perf script
  perf ui/browser: Integrate script browser into annotation browser
  perf ui/browser: Integrate script browser into main hists browser

 tools/perf/Makefile                                |    5 +
 tools/perf/builtin-script.c                        |   49 ++++++
 tools/perf/builtin.h                               |    1 +
 .../python/bin/event_analyzing_sample-record       |    8 +
 .../python/bin/event_analyzing_sample-report       |    3 +
 tools/perf/ui/browsers/annotate.c                  |    8 +
 tools/perf/ui/browsers/hists.c                     |   39 +++++
 tools/perf/ui/browsers/scripts.c                   |  159 ++++++++++++++++++++
 tools/perf/ui/browsers/scripts.h                   |    5 +
 tools/perf/util/event.c                            |    5 +-
 10 files changed, 280 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-record
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-report
 create mode 100644 tools/perf/ui/browsers/scripts.c
 create mode 100644 tools/perf/ui/browsers/scripts.h

