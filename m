Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1EJHYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:24:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49005 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1EJHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:24:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E827.8020605@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:24:23 +0900
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
Subject: Re: [patch 10/15] sched: allow for positional tg_tree walks
References: <20110503092846.022272244@google.com> <20110503092905.340562757@google.com>
In-Reply-To: <20110503092905.340562757@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
> Extend walk_tg_tree to accept a positional argument
> 
> static int walk_tg_tree_from(struct task_group *from,
> 			     tg_visitor down, tg_visitor up, void *data)
> 
> Existing semantics are preserved, caller must hold rcu_lock() or sufficient
> analogue.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Yeah, it's nice to have.

Thanks,
H.Seto

