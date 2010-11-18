Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0KRIkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:40:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:54145 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab0KRIkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:40:21 -0500
Message-ID: <4CE4E655.30207@kernel.org>
Date: Thu, 18 Nov 2010 09:39:49 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Subject: Re: [PATCH 4/9 UPDATED-1] x86: Initialize 32bit logical apicid mapping
 early during boot
References: <1289473363-29440-1-git-send-email-tj@kernel.org> <1289473363-29440-5-git-send-email-tj@kernel.org> <4CDD17EC.8000507@kernel.org> <20101118083045.GB26398@elte.hu>
In-Reply-To: <20101118083045.GB26398@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 08:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Ingo.

On 11/18/2010 09:30 AM, Ingo Molnar wrote:
> This patch is still _WAY_ too large.

Really?  Alright, I'll split it further.

> Also, these:
> 
>> +#ifdef CONFIG_X86_32
>> +#endif
> 
>> +#ifdef CONFIG_X86_32
>> +#endif
> 
>> +#ifdef CONFIG_X86_32
>> +#endif
> 
>> +#ifdef CONFIG_X86_32
>> +#endif
> 
> Are rather ugly.

Yeah, what they do is ugly.  It gets less uglier after the patchset.
I'll see if some of them can be dropped but I don't think putting them
inside ifdef'd inline functions necessarily improves things.  It often
just makes things more difficult to follow.

Thanks.

-- 
tejun
