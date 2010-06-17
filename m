Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab0FQIkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab0FQIkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:40:35 -0400
Message-ID: <4C19DF80.6060909@redhat.com>
Date: Thu, 17 Jun 2010 11:40:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 0/9] rework KVM mmu_shrink() code
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <4C188D8B.40508@redhat.com> <1276700596.6437.16867.camel@nimitz>
In-Reply-To: <1276700596.6437.16867.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 06:03 PM, Dave Hansen wrote:
> On Wed, 2010-06-16 at 11:38 +0300, Avi Kivity wrote:
>    
>> On 06/15/2010 04:55 PM, Dave Hansen wrote:
>>      
>>> These seem to boot and run fine.  I'm running about 40 VMs at
>>> once, while doing "echo 3>   /proc/sys/vm/drop_caches", and
>>> killing/restarting VMs constantly.
>>>
>>>        
>> Will drop_caches actually shrink the kvm caches too?  If so we probably
>> need to add that to autotest since it's a really good stress test for
>> the mmu.
>>      
> I'm completely sure.

Yes, easily seen from the code as well.

> I crashed my machines several times this way
> during testing.
>    

Hopefully only with your patches applied?

I'll try to run autotest from time to time with drop_caches running in 
the background.  Looks like an excellent way to stress out the mmu.


-- 
error compiling committee.c: too many arguments to function

