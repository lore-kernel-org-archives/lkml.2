Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2DAUDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:03:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50975 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2DAUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:03:11 -0400
Date: Sun, 1 Apr 2012 13:03:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        ctalbott@google.com, rni@google.com
Subject: [GIT PULL] block/for-3.5/core: pull in cgroup/for-3.5
Message-ID: <20120401200306.GB9230@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

cgroup/for-3.5 currently contains the following changes which
blk-cgroup needs to proceed with the on-going cleanup.

* Dynamic addition and removal of cftypes to make config/stat file
  handling modular for policies.

* cgroup removal update to not wait for css references to drain to fix
  blkcg removal hang caused by cfq caching cfqgs.

Due to the extensive changes in blk-cgroup.c, the pull results in some
non-trivial conflicts which can be a bit tricky to resolve correctly.

The following branch contains the merged commit.  Please feel free to
pull in as-is or use it as reference.  Stephen, cgroup and block next
branches will cause nasty conflicts until this merge happens, please
use this commit as merge reference or skip cgroup/for-3.5 for the time
being.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-core-cgroup-merge

Thank you.

-- 
tejun
