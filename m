Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1K1VqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:46:19 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:64225 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1K1VqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:46:18 -0500
Date: Mon, 28 Nov 2011 13:46:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] cgroup fixes for 3.2-rc3
Message-ID: <20111128214612.GC3858@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull contains cgroup_freezer fix for the regression introduced by
2d3cbf8b "cgroup_freezer: update_freezer_state() does incorrect state
transitions" committed about one year ago.  It broke FREEZING ->
FROZEN transition when the cgroup contains stopped tasks.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.2-fixes

Michal Hocko (1):
      cgroup_freezer: fix freezing groups with stopped tasks

 kernel/cgroup_freezer.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

Thanks.

--
tejun
