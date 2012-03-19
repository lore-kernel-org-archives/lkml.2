Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2CSXIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:08:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58198 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab2CSXIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:08:23 -0400
Date: Mon, 19 Mar 2012 16:08:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Subject: [GIT PULL] workqueue changes for v3.4
Message-ID: <20120319230819.GB2873@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue changes for
v3.4.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.4

It contains only one commit which cleans up UP allocation path a bit.

Thanks.

Lai Jiangshan (1):
      workqueue: use percpu allocator for cwq on UP

 kernel/workqueue.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

--
tejun
