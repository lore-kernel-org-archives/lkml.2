Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2HQQ63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:58:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47220 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab2HQQ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:58:20 -0400
Subject: Re: [RFC PATCH 0/1] sched: Add a new API to find the prefer idlest
 cpu
From: Shirley Ma <mashirle@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, vivek@us.ibm.com,
        sri@us.ibm.com
In-Reply-To: <1345222134.29668.63.camel@twins>
References: <1343026634.13461.15.camel@oc3660625478.ibm.com>
	 <1345217986.16533.1.camel@oc3660625478.ibm.com>
	 <1345222134.29668.63.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Aug 2012 09:58:11 -0700
Message-ID: <1345222691.16533.7.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081716-7182-0000-0000-0000025189F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 18:48 +0200, Peter Zijlstra wrote:
> On Fri, 2012-08-17 at 08:39 -0700, Shirley Ma wrote:
> 
> > Hello Ingo, Peter,
> >         Have you had chance to review below patch?
> 
> Well no of course not, nobody CC'ed us..
> 
> Your patch submission sucks, you split the changelog and the actual
> patch into two different emails.
> 
> It doesn't mention who would be calling this and how often. Nor does
> it
> seem to explain where the cpumask arguments come from.
> 
> Please try again.

Thanks for your comments. I must be spoiled by net-dev maintainers. I
used to submit the patch this way thought my linux email in the past
many years. So I need to reply on the changelog for the actual patch? I
hope I won't make any more suck submissions again.

I will try to explain more details why this API needs to be exported.

Thanks again.
Shirley

