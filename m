Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1EXUPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:15:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37792 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1EXUPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:15:04 -0400
Date: Tue, 24 May 2011 16:14:52 -0400 (EDT)
Message-Id: <20110524.161452.895009516730675746.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: joe@perches.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for May 24 (ratelimits, CONFIG_PRINTK not
 enabled)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DDC1107.4050004@oracle.com>
References: <1306266580.2298.55.camel@Joe-Laptop>
	<20110524.155337.1293466135362760665.davem@davemloft.net>
	<4DDC1107.4050004@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 May 2011 13:14:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 24 May 2011 13:11:51 -0700

> On 05/24/11 12:53, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Tue, 24 May 2011 12:49:40 -0700
>> 
>>> On Tue, 2011-05-24 at 15:32 -0400, David Miller wrote:
>>>> From: Joe Perches <joe@perches.com>
>>>> Date: Tue, 24 May 2011 11:49:48 -0700
>>>>> On Tue, 2011-05-24 at 11:33 -0700, Randy Dunlap wrote:
>>>>>> Adding <linux/ratelimit.h> to <asm-generic/bug.h> causes other problems:
>>>>> Yup, that's not a good solution.
>>>> Please come up with a fix or I'll have to revert, thanks Joe.
>>>
>>> I have some errands to run for awhile.
>>>
>>> Probably a revert today and another patch set tomorrow
>>> might be best.
>>>
>>> This seems to work and doesn't cause any extra state to be
>>> instantiated when !CONFIG_PRINTK.  What do you think?
>> 
>> Seems fine, here it is as a patch.
>> 
>> Randy please test this, thanks:
> 
> Works here.
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks Randy, once my allmodconfig+!CONFIG_PRINTK build finishes
I'll push this out.
