Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1AQKtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:49:55 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35582 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1AQKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:49:53 -0500
Message-ID: <4D341ECD.3020503@linux.vnet.ibm.com>
Date: Mon, 17 Jan 2011 16:19:49 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: [RFC][PATCH 0/2 v1.0]sched: updating /proc/schedstat
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is the first version of the patch set, which updates the /proc/schedstat statistics. Please review the patches and let me know your thoughts.

Ciju Rajan K  (2):
    sched: Removing unused fields from /proc/schedstat
    sched: Updating the sched-stat documentation

 Documentation/scheduler/sched-stats.txt |  140 +++++++++++---------------------
 include/linux/sched.h                   |   11 --
 kernel/sched.c                          |    1 
 kernel/sched_debug.c                    |    1 
 kernel/sched_stats.h                    |   13 +-
 5 files changed, 56 insertions(+), 110 deletions(-)

-Ciju
