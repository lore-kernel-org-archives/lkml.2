Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2DXXLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:11:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45955 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab2DXXLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:11:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 0/2] res_counter: Merge some common code
Date: Wed, 25 Apr 2012 01:11:34 +0200
Message-Id: <1335309096-12886-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small code factorizing. I hope Glauber can have a look at the second
patch to confirm this is what we want for the net memcg controller (that
is the only user of the nofail version AFAICS).

Thanks.

Frederic Weisbecker (2):
  res_counter: Merge res_counter_charge and res_counter_charge_nofail
  res_counter: Account max_usage when calling
    res_counter_charge_nofail()

 Documentation/cgroups/resource_counter.txt |    4 +-
 include/linux/res_counter.h                |    2 +-
 kernel/res_counter.c                       |   71 +++++++++++++---------------
 3 files changed, 36 insertions(+), 41 deletions(-)

-- 
1.7.5.4

