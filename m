Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab2JLRNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:13:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1945929Ab2JLRMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:12:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,578,1344182400"; 
   d="scan'208";a="5990992"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/4] srcu: Add DEFINE_SRCU()
Date: Sat, 13 Oct 2012 01:14:13 +0800
Message-Id: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize complete at 2012/10/13 01:12:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add a simple DEFINE_SRCU() which define and init
the srcu struct in build time, and allow us use srcu in very early
boot time.

Lai Jiangshan (4):
  srcu: add my name
  srcu: export process_srcu()
  srcu: add DEFINE_SRCU
  rcutorture: use DEFINE_STATIC_SRCU()

 include/linux/srcu.h |   34 ++++++++++++++++++++++++++++++++++
 kernel/rcutorture.c  |   41 ++++++-----------------------------------
 kernel/srcu.c        |    8 ++++----
 3 files changed, 44 insertions(+), 39 deletions(-)

-- 
1.7.7.6

