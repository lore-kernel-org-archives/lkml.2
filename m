Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1FIO5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:57:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:46958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1FIO5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:57:37 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Fixes for X.Y kernel versions
Date: Thu,  9 Jun 2011 16:57:23 +0200
Message-Id: <1307631448-29848-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Updated series to fix various kbuild parts to deal with a two-number kernel
versions. I'll send you a pull request once git.kernel.org is up to date.

Changes since v1:
- Also support single-number kernel versions, just for fun.
- Moved the depmod stuff to scripts/depmod.sh to keep the Makefile tidy
- Check if the depmod hack is actually needed, as we have
  a fixed module-init-tools since last week.

Michal

Michal Marek (5):
  kbuild: Fix KERNELVERSION for empty SUBLEVEL or PATCHLEVEL
  kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL
  kbuild: Move depmod call to a separate script
  kbuild: Hack for depmod not handling X.Y versions
  perf: Use make kernelversion instead of parsing the Makefile

 Makefile                         |   16 ++----------
 scripts/depmod.sh                |   48 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/PERF-VERSION-GEN |    7 +----
 3 files changed, 52 insertions(+), 19 deletions(-)
 create mode 100755 scripts/depmod.sh

-- 
1.7.4.2

