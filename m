Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2JTQaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:30:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2JTQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:30:23 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 0/3] workqueue: minor cleanup
Date: Sun, 21 Oct 2012 01:30:04 +0900
Message-Id: <1350750607-2051-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset do minor cleanup for workqueue code.

First patch makes minor behavior change, however, it is trivial.
Others doesn't makes any functional difference.
These are based on v3.7-rc1

Joonsoo Kim (3):
  workqueue: optimize mod_delayed_work_on() when @delay == 0
  workqueue: trivial fix for return statement in work_busy()
  workqueue: remove unused argument of wq_worker_waking_up()

 kernel/sched/core.c      |    2 +-
 kernel/workqueue.c       |   11 +++++++----
 kernel/workqueue_sched.h |    2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
1.7.9.5

