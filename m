Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1BRMna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:43:30 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49093 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1BRMn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:43:27 -0500
Message-ID: <4D5E6970.1000105@linux.vnet.ibm.com>
Date: Fri, 18 Feb 2011 18:13:28 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [RFC][PATCH 0/2 v3.0]sched: updating /proc/schedstat
References: <4D3F3595.4020607@linux.vnet.ibm.com>
In-Reply-To: <4D3F3595.4020607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is the v3.0 of the patch set, which updates 
/proc/schedstat statistics. Please review the patches
and consider for inclusion.

Changes from v2.0:
 * Re-based to linux-2.6-tip
 * Added Tested-by tag

Changes from v1.0:
 * Fixed couple of typos
 * Re-written the documentation for sched-domain statistics
 * Re-based to 2.6.38-rc2

Previous versions of the patches were posted here:
 (v1.0) https://lkml.org/lkml/2011/1/17/87
 (v2.0) https://lkml.org/lkml/2011/1/25/456

-Ciju


 Documentation/scheduler/sched-stats.txt |  144 ++++++++++++--------------------
 include/linux/sched.h                   |   11 --
 kernel/sched_debug.c                    |    1 
 kernel/sched_stats.h                    |   13 +-
 4 files changed, 60 insertions(+), 109 deletions(-)
