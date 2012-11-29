Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2K2InE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2K2InC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:02 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299568"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/8] srcu: cleanup for 3.8
Date: Thu, 29 Nov 2012 16:46:01 +0800
Message-Id: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:31,
	Serialize complete at 2012/11/29 16:42:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul

These are tiny cleanups for srcu.

PATCH 4~8 make the code or the comments match the new SRCU.

Thanks,
Lai

Lai Jiangshan (8):
  srcu: simplify __srcu_read_unlock() via this_cpu_dec()
  srcu: add might_sleep() annotation to synchronize_srcu()
  srcu: simple cleanup for cleanup_srcu_struct()
  srcu: srcu_read_lock() can be called from offline cpu
  srcu: srcu_read_lock() can be called from idle loop
  srcu: update the comments of synchronize_srcu()
  srcu: update the comments of synchronize_srcu_expedited()
  srcu: use ACCESS_ONCE() to access sp->completed in srcu_read_lock()

 include/linux/srcu.h |   26 +++-----------------------
 kernel/srcu.c        |   37 ++++++++++++++++---------------------
 2 files changed, 19 insertions(+), 44 deletions(-)

-- 
1.7.4.4

