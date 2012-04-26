Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2DZRjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:39:21 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:46641 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751255Ab2DZRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:39:19 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 26 Apr 2012 10:39:10 -0700
Message-Id: <1335461950-30597-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/ib-fixes

----------------------------------------------------------------

A few fixes for regressions introduced in 3.4-rc1:
 - fix memory leak in mlx4
 - fix two problems with new MAD response generation code

----------------------------------------------------------------
Jack Morgenstein (2):
      IB/mad: Set 'D' bit in response for unhandled MADs
      IB/mad: Don't send response for failed MADs

Jesper Juhl (1):
      IB/mlx4: Fix memory leaks in ib_link_query_port()

Roland Dreier (1):
      Merge branches 'mad-response' and 'mlx4' into fixes

 drivers/infiniband/core/mad.c     |    8 +++++---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)
