Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0H0Nho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:37:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37741 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0H0Nhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X/jatIW1S969oxac3FzKGN40IOVZBhxJX/3OVKBTj1SM+wZkSZn1dvOXXeGS3qbkUE
         VpODSg1xPI7v+k8wlgex6vWtErrLNA/xIcwrsJ2WYIfMGtc1WgM6WqN4/f260o5RaAum
         kJW6tVNauhJ3FAfV3woyl24gAMy7rVJAcN6xk=
Date: Fri, 27 Aug 2010 15:37:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: DDD <dongdong.deng@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, acme@redhat.com,
        paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix possible divide-by-zero in
	perf_swevent_overflow()
Message-ID: <20100827133735.GC5241@nowhere>
References: <1282824438-13970-1-git-send-email-dongdong.deng@windriver.com> <1282824727.1975.747.camel@laptop> <4C765FD3.9060904@windriver.com> <1282827486.1975.845.camel@laptop> <4C77ADC1.5030502@windriver.com> <1282913445.1975.2414.camel@laptop> <4C77BB6B.9090706@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C77BB6B.9090706@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:19:39PM +0800, DDD wrote:
> Peter Zijlstra wrote:
>> On Fri, 2010-08-27 at 20:21 +0800, DDD wrote:
>>
>>>>> Maybe the root cause was from kgdb/hw_breakpoint_layer,
>>>> Yeah, I think there's a bug in the hw_breakpoint stuff, does something
>>>> like the below fix it?
>>
>>> Thanks for your patch, but I still could reproduce the problem with 
>>> your patch.
>>
>> Frederic, any clue as to what makes hw breakpoints go funny and have
>> last_period == 0?
>
> Hi Peter,
>
> Thanks for you take care of it, I have got the root cause of it now.
>
> It is the kgdb using hw_breakpoint_layer's API problem, and I have a RFC  
> patch for it.(maybe it is not correctly), I will contact with Jason to  
> fix this problem.
>
> Thank you very much,
> Dongdong


Thanks!

We are waiting for your patch then.

