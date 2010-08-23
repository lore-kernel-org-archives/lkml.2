Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0HWBdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 21:33:20 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:52928 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455Ab0HWBdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:33:18 -0400
Date: Mon, 23 Aug 2010 11:33:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] radix_tree: fix writeback regressions
Message-ID: <20100823013315.GG31488@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the following radix tree fixes needed for
regressions caused by the new sync writeback livelock code? Thanks.

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:

  Linux 2.6.36-rc1 (2010-08-15 17:41:37 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git radix-tree

Dave Chinner (2):
      radix-tree: clear all tags in radix_tree_node_rcu_free
      radix-tree: radix_tree_range_tag_if_tagged() can set incorrect tags

 lib/radix-tree.c |   63 +++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 15 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
