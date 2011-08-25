Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1HYReP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab1HYReN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:34:13 -0400
Date: Thu, 25 Aug 2011 13:34:06 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Message-Id: <cover.1314291909.git.jbaron@redhat.com>
Subject: [PATCH 0/4] dynamic debug: cleanups + compile fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a re-post of the last 3 patches, as requested by Greg:
https://lkml.org/lkml/2011/8/11/378

I've also added a compile fix that Randy Dunlap found in the -next tree.

Thanks,

-Jason


Jason Baron (4):
  dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
  dynamic_debug: remove num_enabled accounting
  dynamic_debug: use a single printk() to emit msgs
  dynamic_debug: fix undefined reference to `__netdev_printk'

 include/linux/dynamic_debug.h |   64 ++++++++++++++++++---------------
 lib/dynamic_debug.c           |   77 ++++++++++++++++------------------------
 2 files changed, 66 insertions(+), 75 deletions(-)

-- 
1.7.5.4

