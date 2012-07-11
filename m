Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2GKRCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:02:53 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53859 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab2GKRCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:02:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/10] mm: memcg: charge/uncharge improvements v2
Date: Wed, 11 Jul 2012 19:02:12 +0200
Message-Id: <1342026142-7284-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

second version of tiny charge/uncharge improvements, with incorporated
feedback and acks added (thanks guys).

changes:
o fixed the 03/10 PageSwapCache check in end_migration(), spotted by Kame
o dropped the v1 03/11 shmem patch in favor of Hugh's cleanup
o included default group charging comment fix in 07/10, spotted by Wanpeng

 include/linux/memcontrol.h |   11 +--
 mm/memcontrol.c            |  207 +++++++++++++++++++++++---------------------
 mm/migrate.c               |   27 ++-----
 mm/swapfile.c              |    3 +-
 4 files changed, 119 insertions(+), 129 deletions(-)

