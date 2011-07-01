Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1GABJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:09:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3381 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1GABJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:09:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 0/2] netpoll: Trivial updates
Date: Thu, 30 Jun 2011 18:08:56 -0700
Message-Id: <cover.1309482314.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: WANG Cong <amwang@redhat.com>

Joe Perches (2):
  netpoll: Remove unused EXPORT_SYMBOLs of netpoll_poll and netpoll_poll_dev
  netpoll: Remove trivial wrapper function netpoll_poll

 include/linux/netpoll.h |    2 --
 net/core/netpoll.c      |   13 +++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

-- 
1.7.6.rc1

