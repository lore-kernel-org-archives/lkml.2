Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1JUGgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 02:36:40 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:54692 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1JUGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 02:36:39 -0400
Message-ID: <4EA112F4.3040708@profihost.ag>
Date: Fri, 21 Oct 2011 08:36:36 +0200
From: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Reply-To: p.herz@profihost.ag
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
References: <4E9D53FF.7090609@profihost.ag>            <m2ipnmz49x.fsf@firstfloor.org> <16605.1319145104@turing-police.cc.vt.edu>
In-Reply-To: <16605.1319145104@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by p.herz@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 18 Oct 2011 08:51:54 PDT, Andi Kleen said:
>> Philipp Herz - Profihost AG<p.herz@profihost.ag>  writes:
>>
>>> After updating kernel (x86_64) to stable version 3 there are a few
>>> messages appearing in the kernel log such as
>>>
>>> kworker/0:1: page allocation failure: order:1, mode:0x20
>>> mysql: page allocation failure: order:1, mode:0x20
>>> php5: page allocation failure: order:1, mode:0x20
>>
>> You just ran out of memory.
>
> I read it as "Why is this happening when the previous kernel didn't have
> this issue?", which is a *much* more complicated question...

Exactly, that was the intention of my post.

It would me nice to know, if these messages do require to focus on 
memory statitics?

Looking at our monitoring data, the system does have enough memory 
available.

How do processes get effected, when they are running into situations 
where kernel memory manager tells them about "page allocation failure"?

Is it just meant to be a warning/debugging message new to current kernel 
version 3?

How can we solve the situation? Getting rid of these message, by

- just suppressing
- increasing system's memory
- change kernel and/or kernel runtime config

?

Kind regards,
Philipp
