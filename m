Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0DSKtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab0DSKtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:49:08 -0400
Message-ID: <4BCC3520.6090305@redhat.com>
Date: Mon, 19 Apr 2010 13:49:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BCA026D.3070309@redhat.com> <1271673975.1674.763.camel@laptop>
In-Reply-To: <1271673975.1674.763.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:46 PM, Peter Zijlstra wrote:
> On Sat, 2010-04-17 at 21:48 +0300, Avi Kivity wrote:
>    
>>> After this patch is applied, I don't see a single warp in time during 5 days
>>> of execution, in any of the machines I saw them before.
>>>
>>>
>>>        
>> Please define a cpuid bit that makes this optional.  When we eventually
>> enable it in the future, it will allow a wider range of guests to enjoy it.
>>      
> Right, so on x86 we have:
>
> X86_FEATURE_CONSTANT_TSC, which only states that TSC is frequency
> independent, not that it doesn't stop in C states and similar fun stuff.
>
> X86_FEATURE_TSC_RELIABLE, which IIRC should indicate the TSC is constant
> and synced between cores.
>
>    

Sockets and boards too?  (IOW, how reliable is TSC_RELIABLE)?

-- 
error compiling committee.c: too many arguments to function

