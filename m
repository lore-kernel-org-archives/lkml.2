Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab0FQPzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:55:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:36788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756264Ab0FQPz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:55:29 -0400
Message-ID: <4C1A4548.3020602@kernel.org>
Date: Thu, 17 Jun 2010 17:54:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, bphilips@suse.de,
       yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org>	<1276443098-20653-10-git-send-email-tj@kernel.org>	<20100616204854.4b036f87@infradead.org>	<4C19DA64.8000409@kernel.org>	<alpine.LFD.2.00.1006171310560.4290@localhost.localdomain>	<4C1A05AF.5010405@kernel.org> <20100617124343.5889067c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617124343.5889067c@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 15:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 01:43 PM, Alan Cox wrote:
> On Thu, 17 Jun 2010 13:23:27 +0200
> Tejun Heo <tj@kernel.org> wrote:
> 
>> On 06/17/2010 01:12 PM, Thomas Gleixner wrote:
>>>> Hmmm.... oh, I see.  Wouldn't it be much better to use moving avg of
>>>> IRQ durations instead of letting the driver specify it?  Drivers are
>>>> most likely to just hard code it and It's never gonna be accurate.
>>>
>>> Right, but that's probably more accurate than the core code heuristics
>>> ever will be.
>>
>> Eh, not really.  For ATA at least, there will be three different
>> classes of devices.  SSDs, hard drives and optical devices
> 
> At least four: It may also be battery backed RAM.

Yeah, right, there are those crazy devices too but I think they would
fall in a single tick any way.  At any rate, let's say I have those
numbers, how would I feed it into c-state selection?

Thanks.

-- 
tejun

