Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767Ab0FJUKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:10:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38817 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759638Ab0FJUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MK1siLHpb2AiMLk0UYV3lB7QvaYEj3dSlGXSRuqFHSfr4HoK21N9oEP9QKMWrxb8A6
         JoC4FG+8laZkFe+7GYRst4I/xHtI8hSi7BvAhwHmTMzXNEZ/HoFcYvYS7Z6ZSa/Nl4Fs
         R9XLqWlPmwFplJB2rHJZ7l9TaTU35DeveUFBg=
Message-ID: <4C1146CF.6070205@gmail.com>
Date: Thu, 10 Jun 2010 13:10:55 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, x86@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables
 in per cpu
References: <20100610110.764742110@firstfloor.org> <20100610111036.DAE8EB1A2C@basil.firstfloor.org> <4C10C930.9080900@kernel.org> <20100610120951.GC16514@elte.hu> <4C112452.60200@gmail.com> <20100610181007.GH19561@basil.fritz.box>
In-Reply-To: <20100610181007.GH19561@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 11:10 AM, Andi Kleen wrote:
>> Thanks for this.. I applied it over
>> here.. and now don't have all of
>> that spam from percpu while compiling
>> the kernel..
>
> Which gcc version are you using?
>>
>> only one I see now is something about
>> warning: variable 'gfp' set but not used
>
> That's fixed in 'IRQ: Move alloc_desk_mask variables inside ifdef'
>
> The whole series fixes a lot more warnings, however
> there are still quite some left (in my config)
>
> -Andi


o.k. I applied your patches, except
patch #10 x86: percpu: Avoid warnings of unused variables

will try later on and see.

as for the warnings, I can send a seperate
post for all to see, still quit a bit
but lots nicer after your patch(s)

Justin P. Mattock	
