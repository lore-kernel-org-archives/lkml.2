Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab0ICVZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:25:47 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59821 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754079Ab0ICVZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:25:46 -0400
Date: Fri, 3 Sep 2010 14:25:45 -0700
From: Arthur Kepner <akepner@sgi.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [RFC/PATCH] notify user-level IRQ balancer when kernel assigns
	IRQ affinity
Message-ID: <20100903212545.GQ2464@sgi.com>
References: <20100903210554.GO2464@sgi.com> <4C81643F.5070801@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C81643F.5070801@caviumnetworks.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 02:10:23PM -0700, David Daney wrote:
>> ---
>>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 4877a8c..65c79c7 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -158,4 +158,15 @@ config HAVE_PERF_EVENTS_NMI
>>   	  subsystem.  Also has support for calculating CPU cycle events
>>   	  to determine how many clock cycles in a given period.
>>
>> +config NOTIFY_USER_IRQ_BALANCER
>> +	bool "Notify user-level IRQ balancer (EXPERIMENTAL)"
>> +	default n
>> +	depends on NET&&  X86
>
> Missing a space before that '&&', but more importantly, what part of the  
> patch is x86 specific?
>
>

Hmmm. I see the space in my copy of the message.

Anyway, the X86 dependency is bogus. For a while there was such 
a dependency, but that's gone now. Just forgot to fix that up. 
Will do that now.

-- 
Arthur
