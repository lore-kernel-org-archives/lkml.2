Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab0LRRIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:08:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab0LRRIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:08:39 -0500
Message-ID: <4D0CEA7F.9080603@redhat.com>
Date: Sat, 18 Dec 2010 19:08:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@suse.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net>  <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net> <1292570143.7772.84.camel@marge.simson.net>
In-Reply-To: <1292570143.7772.84.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 09:15 AM, Mike Galbraith wrote:
> BTW, with this vruntime donation thingy, what prevents a task from
> forking off accomplices who do nothing but wait for a wakeup and
> yield_to(exploit)?
>

What's the difference between that and forking off accomplices who 
run(exploit) directly?

Many threads dominating the scheduler has been solved by group 
scheduling.  We need to make sure directed yield doesn't violate that, 
but I don't see new problems.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

