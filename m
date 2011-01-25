Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1AYUl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:41:56 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42398 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1AYUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:41:55 -0500
Message-ID: <4D3F3595.4020607@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 02:11:57 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: [RFC][PATCH 0/2 v2.0]sched: updating /proc/schedstat
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is the v2.0 of the patch set, which updates 
/proc/schedstat statistics. Please review the patches 
and let me know your thoughts.


Changes from v1.0:

* Fixed couple of typos
* Re-written the documentation for sched-domain statistics
* Re-based to 2.6.38-rc2

-Ciju


 Documentation/scheduler/sched-stats.txt |  150 +++++++++++---------------------
 include/linux/sched.h                   |   11 --
 kernel/sched_debug.c                    |    1 
 kernel/sched_stats.h                    |   13 +-
 4 files changed, 61 insertions(+), 114 deletions(-)




