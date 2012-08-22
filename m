Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab2HVPEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:04:52 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:57144 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2HVPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:00:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336348800"; 
   d="scan'208";a="14129447"
Message-ID: <5034F0FD.8040902@citrix.com>
Date: Wed, 22 Aug 2012 15:47:25 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done setup functions and document its
 semantic
References: <1345580561-8506-1-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208212315330.2856@ionos> <20120822135753.GA30964@phenom.dumpdata.com> <alpine.LFD.2.02.1208221618380.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208221618380.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/12 15:19, Thomas Gleixner wrote:
> On Wed, 22 Aug 2012, Konrad Rzeszutek Wilk wrote:
>    
>> On Tue, Aug 21, 2012 at 11:22:03PM +0200, Thomas Gleixner wrote:
>>      
>>> On Tue, 21 Aug 2012, Attilio Rao wrote:
>>>        
>>>> Differences with v1:
>>>> - The patch serie is re-arranged in a way that it helps reviews, following
>>>>    a plan by Thomas Gleixner
>>>> - The PVOPS nomenclature is not used as it is not correct
>>>> - The front-end message is adjusted with feedback by Thomas Gleixner,
>>>>    Stefano Stabellini and Konrad Rzeszutek Wilk
>>>>          
>>> This is much simpler to read and review. Just have a look at the
>>> diffstats of the two series:
>>>
>>>   6 files changed,  9 insertions(+),  8 deletions(-)
>>>   6 files changed, 11 insertions(+),  9 deletions(-)
>>>   5 files changed, 50 insertions(+),  2 deletions(-)
>>>   6 files changed,  2 insertions(+), 65 deletions(-)
>>>   1 files changed,  5 insertions(+),  0 deletions(-)
>>>
>>> versus
>>>
>>>   6 files changed, 10 insertions(+),  9 deletions(-)
>>>   6 files changed, 11 insertions(+), 11 deletions(-)
>>>   5 files changed,  3 insertions(+),  3 deletions(-)
>>>   6 files changed,  4 insertions(+), 20 deletions(-)
>>>   1 files changed,  5 insertions(+),  0 deletions(-)
>>>
>>> The overall result is basically the same, but it's way simpler to look
>>> at obvious and well done patches than checking whether a subtle copy
>>> and paste bug happened in 3/5 of the first version. Copy and paste is
>>> the #1 cause for subtle bugs. :)
>>>
>>> I'm waiting for the ack of Xen folks before taking it into tip.
>>>        
>> I've some extra patches that modify the new "paginig_init" in the Xen
>> code that I am going to propose for v3.7 - so will have some merge
>> conflicts. Let me figure that out and also run this set of patches
>> (and also the previous one .. which I think you didn't have a
>> chance to look since you were on vacation?) on an overnight
>>      
> Which previous one ?
>    

This one:
https://lkml.org/lkml/2012/8/21/369

but I would like to repost the patch serie skipping the referral to 
PVOPS in the commit logs, I will do so right now, so please wait for 
another patch serie.

Attilio
