Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0KHTbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:31:20 -0500
Received: from brinza.cc.columbia.edu ([128.59.29.8]:49881 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0KHTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:31:19 -0500
Message-ID: <4CD850C0.7020609@cs.columbia.edu>
Date: Mon, 08 Nov 2010 14:34:24 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Gene Cooperman <gene@ccs.neu.edu>
CC: Kapil Arya <kapil@ccs.neu.edu>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, hch@lst.de,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com> <4CD5DCE3.3000109@cs.columbia.edu> <20101107194222.GG31077@sundance.ccs.neu.edu> <4CD71A6B.3020905@cs.columbia.edu> <20101107230516.GJ31077@sundance.ccs.neu.edu> <4CD774CA.8030004@cs.columbia.edu> <20101108162630.GN31077@sundance.ccs.neu.edu> <4CD83DF4.4080009@cs.columbia.edu> <20101108183701.GA20262@sundance.ccs.neu.edu>
In-Reply-To: <20101108183701.GA20262@sundance.ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/08/2010 01:37 PM, Gene Cooperman wrote:
> Thanks for the careful response, Oren.  For others who read this,
> one could interpret Oren's rapid post as criticizing the work of
> Andres Lagar Cavilla.  I'm sure that this was not Oren's intention.
> Please read below for a brief clarification of the novelty of SnowFlock.

Err... yes, that was careless of me. I was too focused on
getting the thread back to track. Thanks for pointing out.

>>> about live migration, have you also looked at the work of
>>> Andres Lagar Caviilla on SnowFlock?
>>>      http://andres.lagarcavilla.com/publications/LagarCavillaEurosys09.pdf
>>> He does live migration of entire virtual machines, again with very
>>> small delay.  Of course, the issue for any type of live migration is that
>>> if the rate of dirtying pages is very high (e.g. HPC), then there is
>>> still a delay or slow response, due to page faults to a remote host.
>>
>> VMware, Xen and KVM already do live migration. However, VMs
>> are a separate beast.
>
> I absolutely agree with your point that live migration of
> applications is a different beast, and technically very novel.
>      Since I know Andres Lagar Cavilla personally, I also feel obligated
> to comment why SnowFlock truly is novel in the VM space.  First, as Andres
> writes:
> "SnowFlock is an open-source project [SnowFlock] built on the Xen 3.0.3
> VMM [Barham 2003]."
> In the abstract, Andres points out one of the major points of novelty:
> "To evaluate SnowFlock, we focus on the demanding
> scenario of services requiring on-the-fly creation of hundreds
> of parallel workers in order to solve computationallyintensive
> queries in seconds."
> We must be careful that we don't destroy someone's reputation without
> a careful study of their work.

Yes, it's really nice work - I saw it when I visited there.
(Coincidentally the post-copy idea with Xen appeared also in
VEE 09 briefly before).

Oren.

