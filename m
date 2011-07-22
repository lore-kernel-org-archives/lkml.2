Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1GVNvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:51:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49248 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab1GVNvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:51:08 -0400
Date: Fri, 22 Jul 2011 15:51:03 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [GIT PULL] workqueue changes for v3.1
Message-ID: <20110722135103.GM2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.1

Nothing too interesting.  Some SCSI drivers want workqueue draining so
it got separated out and cancel_rearming_delayed_work[queue]() which
have been deprecated for a while now are finally removed.

Amerigo Wang (1):
    workqueue: remove cancel_rearming_delayed_work[queue]()

Tejun Heo (1):
    workqueue: separate out drain_workqueue() from destroy_workqueue()

 Documentation/feature-removal-schedule.txt |   10 ----
 include/linux/workqueue.h                  |   18 +------
 kernel/workqueue.c                         |   81 ++++++++++++++++++----------
 3 files changed, 55 insertions(+), 54 deletions(-)

Thank you.

--
tejun
