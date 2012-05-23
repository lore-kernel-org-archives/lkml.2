Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127Ab2EWPEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab2EWPD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:03:58 -0400
Message-ID: <4FBCFC4A.7070303@redhat.com>
Date: Wed, 23 May 2012 18:03:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <20120521215127.GH17031@redhat.com> <alpine.LFD.2.02.1205220012020.3231@ionos> <20120521222449.GJ17031@redhat.com> <alpine.LFD.2.02.1205220044460.3231@ionos> <4FBB6E8B.8020200@redhat.com> <20120523144846.GA26974@gmail.com>
In-Reply-To: <20120523144846.GA26974@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 05:48 PM, Ingo Molnar wrote:
>> 
>> This is silly.  Most of the time the kernel is advanced by 
>> incremental patches.  Sometimes it is advanced by minor or 
>> major refactoring.  It is never advanced by personal attacks 
>> on contributors.
> 
> Thomas wasn't so much doing a personal attack, it was pointing 
> out stupidity and then it was mocking the repeated stupidity. He 
> very politely explained his point of view (with which I agree), 

I guess we disagree on what is polite or not.  Mocking, for example,
isn't part of it in my book.

> and then you guys pressed the issue and there's just so many 
> hours in the merge window, so you asked to be flamed ...

There is a theory that flaming is a necessary part of kernel
development, but not all maintainers and developers agree with it.
Unfortunately many influential maintainers do.

> 
> Avi, if you cannot be brought to properly reject incomplete 
> patches going in the wrong direction then others maintainers 
> interested in the code will do it.

I happen not to think this is going in the wrong direction, and I
explained why.

> 
> If you start to consistently require from KVM contributors 
> "incremental updates" in the right direction, not piling crap on 
> crap, then such incidents won't happen. This isn't the first 
> such incident but there's hope that it might be the last one.

Feel free to point out, politely, when such things happen.  Even if you
don't think it will work for some reason, please try it out as an
experiment.

> The rule in arch/x86/ (and many other subsystems) is very 
> simple: we don't speed up crappy code. If you want to speed it 
> up then make it clean first, *then* is it suited for speedups. 
> Crappy code is fragile and bound to introduce bugs, and crappy 
> code leads to continued increased maintenance overhead, so 
> crappy code is basically under a perpetual code freeze until 
> it's uncrapped.

I agree with this as a general principle, but as it happens this
particular bit cannot be uncrapped due to hardware constraints.

-- 
error compiling committee.c: too many arguments to function
