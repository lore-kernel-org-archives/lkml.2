Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1BPRph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:45:37 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49040 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1BPRpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:45:33 -0500
Date: Wed, 16 Feb 2011 23:15:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [CFS Bandwidth Control v4 2/7] sched: accumulate per-cfs_rq
 cpu usage
Message-ID: <20110216174526.GD3415@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031840.979831163@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110216031840.979831163@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-02-15 19:18:33]:

> Introduce account_cfs_rq_quota() to account bandwidth usage on the cfs_rq
> level versus task_groups for which bandwidth has been assigned.  This is
> tracked by whether the local cfs_rq->quota_assigned is finite or infinite
> (RUNTIME_INF).
> 
> For cfs_rq's that belong to a bandwidth constrained task_group we introduce
> tg_request_cfs_quota() which attempts to allocate quota from the global pool
> for use locally.  Updates involving the global pool are currently protected
> under cfs_bandwidth->lock, local pools are protected by rq->lock.
> 
> This patch only attempts to assign and track quota, no action is taken in the
> case that cfs_rq->quota_used exceeds cfs_rq->quota_assigned.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
