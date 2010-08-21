Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab0HUBWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 21:22:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0HUBWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 21:22:39 -0400
Message-ID: <4C6F2A41.70306@redhat.com>
Date: Fri, 20 Aug 2010 15:22:09 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 17/35] Implement getnsboottime kernel API
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>	 <1282291669-25709-18-git-send-email-zamsden@redhat.com>	 <1282329594.3302.39.camel@localhost.localdomain>	 <4C6F11D6.1050101@redhat.com>	 <1282348958.28794.21.camel@localhost.localdomain>	 <4C6F235D.5040100@redhat.com> <1282352655.28794.25.camel@localhost.localdomain>
In-Reply-To: <1282352655.28794.25.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 03:04 PM, john stultz wrote:
> On Fri, 2010-08-20 at 14:52 -1000, Zachary Amsden wrote:
>    
>> I think gettimefromboot_ns() is a good descriptive name, but slightly
>> too long - it would ruin my indentation.  Perhaps getrealtime_ns()?
>>      
> Sigh... So getrealtime_ns would probably be confused with
> CLOCK_REALTIME, which is wall time.  :P
>
> At this point it feels too nitpicky to suggest anything else, so go
> ahead and use boottime_ns and we'll refine things if anyone actually
> trips up on it.
>    

As long as the prototype is adequately commented, there needn't be any 
confusion ;)

Zach
