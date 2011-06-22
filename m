Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1FVKFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:05:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45136 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1FVKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:05:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01BE6B.2090701@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 19:05:31 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
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
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
References: <20110621071649.862846205@google.com>
In-Reply-To: <20110621071649.862846205@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/21 16:16), Paul Turner wrote:
> Hideotoshi, the following patches changed enough, or are new, and should be
> looked over again before I can re-add your Reviewed-by.
> 
> [patch 04/16] sched: validate CFS quota hierarchies
> [patch 06/16] sched: add a timer to handle CFS bandwidth refresh
> [patch 07/16] sched: expire invalid runtime
> [patch 10/16] sched: throttle entities exceeding their allowed bandwidth
> [patch 15/16] sched: return unused runtime on voluntary sleep

Done.

Thank you very much again for your great work! 

I'll continue my test/benchmark on this v7 for a while.
Though I believe no more bug is there, I'll let you know if there is something.

I think it's about time to have this set in upstream branch (at first, tip:sched/???).
(How about having an update with correct words (say, v7.1?) within a few days?)


Thanks,
H.Seto

