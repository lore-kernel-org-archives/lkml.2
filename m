Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1EJHSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:18:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45315 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1EJHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:18:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E69C.8020301@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:17:48 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 02/15] sched: hierarchical task accounting for SCHED_OTHER
References: <20110503092846.022272244@google.com> <20110503092904.629158172@google.com>
In-Reply-To: <20110503092904.629158172@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some typos in the description.

(2011/05/03 18:28), Paul Turner wrote:
> Introduce hierarchal task accounting for the group scheduling case in CFS, as

            hierarchical 

> well as promoting the responsibility for maintaining rq->nr_running to the
> scheduling classes.
> 
> The primary motivation for this is that with scheduling classes supporting
> bandwidht throttling it is possible for entities participating in trottled

  bandwidth                                                         throttled

> sub-trees to not have root visible changes in rq->nr_running across activate
> and de-activate operations.  This in turn leads to incorrect idle and 
> weight-per-task load balance decisions.
> 
> This also allows us to make a small fixlet to the fastpath in pick_next_task()
> under group scheduling.
> 
> Note: this issue also exists with the existing sched_rt throttling mechanism.
> This patch does not address that.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---

The patch is good.

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

