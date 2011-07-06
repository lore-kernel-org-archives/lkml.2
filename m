Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1GFRYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:24:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab1GFRYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:24:42 -0400
Date: Wed, 6 Jul 2011 13:24:31 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
Message-Id: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Subject: [PATCH 00/10] dynamic_debug: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Various dynamic debug fixes and cleanups, and a patch to add myself as
maintainer. Hopefully, nobody will object too loudly :)

Thanks,

-Jason


Joe Perches (4):
  dynamic_debug: Add __dynamic_dev_dbg
  dynamic_debug: Consolidate prefix output to single routine
  dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
  dynamic_debug: Convert printks to pr_<level>

Jason Baron (6):
  dynamic_debug: remove unused control variables
  dynamic_debug: add myslef as maintainer
  dynamic_debug: make netdev_dbg() call __netdev_printk()
  dynamic_debug: make netif_dbg() call __netdev_printk()
  dynamic_debug: consolidate repetitive struct _ddebug descriptor
    definitions
  dynamic_debug: remove num_enabled accounting

 MAINTAINERS                   |    6 ++
 drivers/base/core.c           |    5 +-
 include/linux/device.h        |    5 +
 include/linux/dynamic_debug.h |   58 ++++++++++-----
 include/linux/netdevice.h     |   12 ++--
 lib/dynamic_debug.c           |  165 ++++++++++++++++++++++++++++-------------
 net/core/dev.c                |    3 +-
 7 files changed, 172 insertions(+), 82 deletions(-)

-- 
1.7.5.4

