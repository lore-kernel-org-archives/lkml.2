Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0IBUBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:01:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32321 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0IBUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:01:45 -0400
Message-ID: <4C800266.1000005@oracle.com>
Date: Thu, 02 Sep 2010 13:00:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fix typos
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com> <20100902121853.e90f6c53.randy.dunlap@oracle.com> <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
In-Reply-To: <AANLkTinehv75C+xhsDA_7HHoT9m_BkmL1aE_oyM9BJO4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/10 12:31, Lucas De Marchi wrote:
> On Thu, Sep 2, 2010 at 16:18, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Hi,
>>
>> I'd take most of the corrections in Documentation/, but in general,
>> I don't think that it's a good idea without some careful review.
> 
> I plan to review it if it's indeed worth fixing those typos. I already
> fixed several false positives like  "rela" being changed to "real",
> but since it's a 1.8 MB patch I think it's better to ask first before
> making any other review.
> 
>>
>> E.g.:
>>
>> 1.  changing thru to through isn't needed IMO.
>> Can you add "thru" to your dictionary?
> Yes, no problem
> 
>>
>> 2.
>> -(Warning, pulses on ACK ar inverted by transistor, irq is rised up on sync
>> +(Warning, pulses on ACK ar inverted by transistor, irq is rose up on sync
>>
> Humn.. indeed this seems to be a bad typo in my dictionary.
> 
>> I'm not so sure about "is rose up" being better.  and what about "ar"?
> 
> I'm only changing words with 3 chars or more, because otherwise I
> would have a lot of false positives, but I think I can add this word
> without much trouble.
> 

Mike's suggested change is good here.

>>
>> I saw a few others that I could comment on, but I lost them in the 1.8 MB patch file.
> 
> If you say it's good, I can review it more carefully.

It looks good for Documentation/.

And fixing typos is certainly something that we want to do in
user-visible messages, like printk strings.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
