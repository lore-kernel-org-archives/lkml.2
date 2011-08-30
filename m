Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1H3S2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab1H3S2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:28:44 -0400
Date: Tue, 30 Aug 2011 14:28:38 -0400
From: Jason Baron <jbaron@redhat.com>
To: jbaron@redhat.com
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Message-Id: <cover.1314725877.git.jbaron@redhat.com>
Subject: [PATCH 0/4] dynamic debug: cleanups + compile fix v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Re-post of: https://lkml.org/lkml/2011/8/25/493

changes since v1:
-ensure that dynamic_emit_prefix() adds a trailing space, where appropriate,
 and terminates strings with a '\0'.
-add a parentheses around the 'fmt' macro argument (although it has no effect)

Thanks,

-Jason

Jason Baron (4):
  dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
  dynamic_debug: remove num_enabled accounting
  dynamic_debug: use a single printk() to emit msgs
  dynamic_debug: fix undefined reference to `__netdev_printk'

 include/linux/dynamic_debug.h |   64 +++++++++++++++++--------------
 lib/dynamic_debug.c           |   83 ++++++++++++++++++----------------------
 2 files changed, 72 insertions(+), 75 deletions(-)

-- 
1.7.5.4

