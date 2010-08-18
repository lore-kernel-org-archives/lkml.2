Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0HRPt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:49:58 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51877 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0HRPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:11 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 00/16] update checkpatch to v0.31
Date: Wed, 18 Aug 2010 16:46:33 +0100
Message-Id: <1282146409-30544-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a long hiatus here is a batch of checkpatch updates from my tree.
I have resynced with the version in v2.6.36-rc1 and added tests for all
of the changes therein.  This has thrown up a couple of regressions introduced
in those changes.  This update includes fixes for those, as below:

  checkpatch: fix regressions in "fix handling of leading spaces"
  checkpatch: ensure kconfig help checks only apply when we are adding help

The rest of my commits mostly fixes for false positives reported directly
to me.  There are also a couple of fixes from Joe and Rabin which I've
integrated and tested.

Joe et al thanks for chiming in on many of the pending threads, most
helpful.

Complete changelog below.

-apw

Andy Whitcroft (14):
  checkpatch: fix regressions in "fix handling of leading spaces"
  checkpatch: types may sit on a line on their own
  checkpatch: suggest cleanpatch and cleanfile when appropriate
  checkpatch: ensure we do not collapse bracketed sections into constants
  checkpatch: handle casts better fixing false categorisation of : as binary
  checkpatch: returning errno typically should be negative
  checkpatch: add check for space after struct, union, and enum
  checkpatch: simplify and consolidate "missing space after" checks
  checkpatch: ensure kconfig help checks only apply when we are adding help
  checkpatch: update copyright dates
  checkpatch: clean up structure definition macro handline
  checkpatch: handle EXPORT_SYMBOL for DEVICE_ATTR and similar
  checkpatch: statement/block context analyser should look at sanitised lines
  checkpatch: version 0.31

Joe Perches (1):
  checkpatch: Add additional attribute #defines

Rabin Vincent (1):
  checkpatch: check for incorrect permissions

 scripts/checkpatch.pl |  133 ++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 109 insertions(+), 24 deletions(-)

