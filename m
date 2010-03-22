Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0CVOoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:44:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33396 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0CVOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:43:58 -0400
Message-ID: <4BA7821C.7090900@codemonkey.ws>
Date: Mon, 22 Mar 2010 09:43:40 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu>
In-Reply-To: <20100322143212.GE14201@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 09:32 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/22/2010 02:44 PM, Ingo Molnar wrote:
>>      
>>> This is why i consider that line of argument rather dishonest ...
>>>        
>> I am not going to reply to any more email from you on this thread.
>>      
> Because i pointed out that i consider a line of argument intellectually
> dishonest?
>
> I did not say _you_ as a person are dishonest - doing that would be an ad
> honimen attack against your person. (In fact i dont think you are, to the
> contrary)
>
> An argument can certainly be labeled dishonest in a fair discussion and it is
> not a personal attack against you to express my opinion about that.
>    

You're being excessively rude in this thread.  That might be acceptable 
on LKML but it's not how the QEMU and KVM communities behave.  This 
thread is a good example of why LKML has the reputation it has.  Avi and 
I argue all of the time on qemu-devel and kvm-devel and it's never 
degraded into a series of personal attacks like this.

I've been trying very hard to turn this into a productive thread 
attempting to capture your feedback and give clear suggestions about how 
you can solve achieve your desired functionality.

What are you looking to achieve?  To you just want to piss and moan 
about how terrible you think Avi and I are?  Or do you want to try to 
actually help make things better?

If you want to help make things better, please focus on making 
constructive suggestions and clarifying what you see as requirements.

Regards,

Anthony Liguori

