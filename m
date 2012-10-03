Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2JCIpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:45:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:40500 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab2JCInK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="scan'208";a="229356991"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 0/6] lib/string: introduce kbasename helper
Date: Wed,  3 Oct 2012 11:42:57 +0300
Message-Id: <1349253783-21612-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in kernel that duplicate code to get last part of the pathname.
This patchset introduces a helper.

Since v1:
 - fix changelog of the patch 1 - we are doing basname(3) alike helper
 - usb related patch temporary excluded from series (under discussion with
   Greg)

Andy Shevchenko (6):
  string: introduce helper to get base file name from given path
  lib: dynamic_debug: reuse kbasename()
  staging: rts_pstor: reuse kbasename()
  mm: reuse kbasename() functionality
  procfs: reuse kbasename() functionality
  trace: reuse kbasename() functionality

 drivers/staging/rts_pstor/trace.h |   16 +++-------------
 fs/proc/proc_devtree.c            |    7 ++-----
 include/linux/string.h            |   11 +++++++++++
 kernel/trace/trace_uprobe.c       |    6 +++---
 lib/dynamic_debug.c               |    9 +--------
 mm/memory.c                       |    8 +++-----
 6 files changed, 23 insertions(+), 34 deletions(-)

-- 
1.7.10.4

