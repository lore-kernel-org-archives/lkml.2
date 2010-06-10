Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab0FJRnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:43:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45436 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0FJRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XJPv7svX7RiE5FDhPzxgQ7XKuOixFiaNu53cNQ8d0JR3t1p06P6SOB7wh7fhMh9bPB
         57UuX6sBm3UeUnqkh4cPE/IioC/BUP3lPCzV/bdPlQs0PGwN0dLubQ01HzyJEd28fijm
         ros3xCUH76895MkaGjTCeSr47ebuP8PKKTm4w=
Message-ID: <4C112452.60200@gmail.com>
Date: Thu, 10 Jun 2010 10:43:46 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables
 in per cpu
References: <20100610110.764742110@firstfloor.org> <20100610111036.DAE8EB1A2C@basil.firstfloor.org> <4C10C930.9080900@kernel.org> <20100610120951.GC16514@elte.hu>
In-Reply-To: <20100610120951.GC16514@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 05:09 AM, Ingo Molnar wrote:
>
> * Tejun Heo<tj@kernel.org>  wrote:
>
>> On 06/10/2010 01:10 PM, Andi Kleen wrote:
>>> Avoid hundreds of warnings with a gcc 4.6 -Wall build
>>>
>>> Cc: tj@kernel.org
>>> Cc: x86@kernel.org
>>>
>>> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>>
>> Acked-by: Tejun Heo<tj@kernel.org>
>>
>> Can x86 or -mm please take this patch?  There isn't any pending percpu
>> patch currently and it seems a bit silly to start a branch for this
>> one.
>
> Sure, queued it up.
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


Thanks for this.. I applied it over
here.. and now don't have all of
that spam from percpu while compiling
the kernel..

only one I see now is something about
warning: variable 'gfp' set but not used

if there's another I can test it if you
would like.

Justin P. Mattock
