Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2BTJlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:41:50 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51100 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BTJls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:41:48 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
In-Reply-To: <CAPM31RLWpF0mO2faCfY+HOeThz0iW6_7D+S++pGHtJi6hhiAVQ@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com> <87k43lde0r.fsf@linux.vnet.ibm.com> <CAPM31RLWpF0mO2faCfY+HOeThz0iW6_7D+S++pGHtJi6hhiAVQ@mail.gmail.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 20 Feb 2012 15:11:21 +0530
Message-ID: <87aa4dq1tq.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12021923-5140-0000-0000-000000C578EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 02:48:06 -0800, Paul Turner <pjt@google.com> wrote:
> 
> This is almost certainly a result of me twiddling with the weight in
> calc_cfs_shares (using average instead of instantaneous weight) in
> this version -- see patch 11/14.  While this had some nice stability
> properties it was not hot for fairness so I've since reverted it
> (snippet attached below).
>
For my understanding, what do you mean by stability here?

> 
> 24-core:
> Starting task group fair16...done
> Starting task group fair32...done
> Starting task group fair48...done
> Waiting for the task to run for 120 secs
> Interpreting the results. Please wait....
> Time consumed by fair16 cgroup:  12628615 Tasks: 96
> Time consumed by fair32 cgroup:  12562859 Tasks: 192
> Time consumed by fair48 cgroup:  12600364 Tasks: 288
> 
"Tasks:" should be 16,32,48? 

Regards,
Nikunj

