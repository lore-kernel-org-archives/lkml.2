Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0FJS0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:26:37 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51536 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0FJS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VnsUbMWS7cjRaY5SZ8zqksUardIOHqg4R0ZIb3eh0h7BHIIvFepbuz76z56L28KO/o
         G/exXxRnqM61wSOufSun5AD6hvJvMH9cpWwMsJ8Rvau2OFORyYh0vyNZT4XZ654KOmWi
         N0qHHWcJ2tF431jVicJrm/bmIGBPQTBVwvg8E=
Message-ID: <4C112E60.5020406@gmail.com>
Date: Thu, 10 Jun 2010 11:26:40 -0700
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

  gcc version 4.6.0 20100416
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

let me go and add all of these patches, to see
if I see any more warnings..

Justin P. Mattock
