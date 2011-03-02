Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CBTHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:07:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21602 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1CBTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:07:37 -0500
Message-ID: <4D6E9541.2040201@kernel.org>
Date: Wed, 02 Mar 2011 11:06:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
References: <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org> <20110302102530.GB3319@htj.dyndns.org> <4D6E6D52.8030901@kernel.org> <20110302163729.GQ3319@htj.dyndns.org> <4D6E7459.6050706@kernel.org> <20110302165545.GR3319@htj.dyndns.org> <4D6E91EC.6040906@kernel.org> <20110302190208.GD28266@mtj.dyndns.org>
In-Reply-To: <20110302190208.GD28266@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D6E9566.0021,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 11:02 AM, Tejun Heo wrote:
> Hey, Yinghai.
> 
> On Wed, Mar 02, 2011 at 10:52:28AM -0800, Yinghai Lu wrote:
>>> Complexity of a solution should match the benefit of the complexity.
>>> Code complexity is one of the most important metrics that we need to
>>> keep an eye on.  If you don't do that, the code base becomes very ugly
>>> and difficult to maintain very quickly.  So, yes, some amount of
>>> execution inefficiency is acceptable depending on circumstances.
>>> Efficiency too is something which should be traded off against other
>>> benefits.
>>
>> No. it is not acceptable in your case.
>>
>> We can accept that something like: during init stage, do some probe
>> and call pathes to be happy.  like subarch.
> 
> Hmmm?  I can't really follow your sentence.  This is init stage.
> Anyways, why can't it just walk over the enabled nodes?  What would be
> the difference?

my point is that we really not need to go over it if original is not there.

> 
>> Also why did you omit my first question?
> 
> Yeah, well, because that wasn't completely consistent with what I said
> earlier.  I wanted to tell you to take the assignments out of if () on
> your earlier patch but I just let it pass and now I had this another
> patch touching the same code, so I just had to do it.
> 
> I know it's a petty style thing but it's my pet peeve and I can't help
> it when related change goes through me, so there it is.  I'm sorry but
> I'll probaly do it again.  I beg your understanding.

never mind.

Thanks

Yinghai
