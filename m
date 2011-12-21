Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab1LUCCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:02:47 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64020 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1LUCCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:02:45 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 0/2 v2] cgroup: Remove useless task_lock()
Date: Wed, 21 Dec 2011 03:02:36 +0100
Message-Id: <1324432958-20414-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's the same set but rebased on top of cgroup/for-3.3 instead of
Mandeep's patch.

Although the first patch has changed a bit after the rebase
I have kept the Reviewed-by tag of Li and Mandeep because the
core change itself hasn't changed much.

Second patch is the same.

Thanks.

Frederic Weisbecker (2):
  cgroup: Remove unnecessary task_lock before fetching css_set on
    migration
  cgroup: Drop task_lock(parent) on cgroup_fork()

 kernel/cgroup.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

-- 
1.7.5.4

