Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2CHQVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:21:34 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:41366 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2CHQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:21:33 -0500
Subject: Re: [RFC] Scheduler recorder and playback
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20120308154519.GE7976@somewhere.redhat.com>
Date: Thu, 8 Mar 2012 18:21:25 +0200
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-dev@lists.linaro.org, Steven Goss <steve.goss@ti.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Kumar Gala <galak@ti.com>, Robin Randhawa <robin.randhawa@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, charles.garcia-tobin@arm.com,
        Morten Rasmussen <morten.rasmussen@arm.com>, chris.redpath@arm.com,
        Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        dmitry.antipov@linaro.org, Stephane Sintes <s-sintes@ti.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
Message-Id: <06486CFC-244E-4D52-8A25-719AA0D3E742@antoniou-consulting.com>
References: <85A3EFC3-FAE0-4B3A-AAA0-85FA435A9F7B@antoniou-consulting.com> <20120308154519.GE7976@somewhere.redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Mar 8, 2012, at 5:45 PM, Frederic Weisbecker wrote:

> On Thu, Mar 08, 2012 at 03:20:53PM +0200, Pantelis Antoniou wrote:
>> Hi there,
>> 

[snip]

> 
> Hi,
> 
> May be you could have a look at the perf sched tool.
> It has a replay feature. I think it perform well basic replay but it can
> certainly be enhanced.
> 

Yes I am aware of perf-sched, and I know that it can do basic record and
replay of the wakeup, switch & fork events.

It looks like it can be the starting point of what we're trying to do, but
I doubt this will cover all the cases.

That why I'm trying to have a discussion about this problem; to find out
what is there, what is missing, and what is there to fix or develop anew.

So what do you think?

Regards

-- Pantelis

>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

