Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1BIMjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 07:39:45 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57043 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab1BIMjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 07:39:44 -0500
Message-ID: <4D528B53.7040208@kernel.dk>
Date: Wed, 09 Feb 2011 13:40:51 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Chris Clayton <chris2553@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, simon@fire.lp0.eu,
        kay.sievers@vrfy.org
Subject: Re: 2.6.38-rc2+ - regresiion copying DVD's
References: <201101301550.59272.chris2553@googlemail.com> <201101311929.05290.chris2553@googlemail.com> <201102062312.14919.chris2553@googlemail.com> <20110209095556.GD3770@htj.dyndns.org>
In-Reply-To: <20110209095556.GD3770@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-09 10:55, Tejun Heo wrote:
> On Sun, Feb 06, 2011 at 11:12:14PM +0000, Chris Clayton wrote:
>> Hi again,
>>
>> On Monday 31 January 2011, Chris Clayton wrote:
>>> On Sunday 30 January 2011, Chris Clayton wrote:
>>>> Hi,
>>>>
>>>> Firstly, I'm not subscribed, so please cc me on any reply.
>>>>
>>>> I'm trying to copy the3 contents of a video DVD from one disc to another,
>>>> but it fails. There are no messages in the kernel log file, but K3B
>>>> reports the following:
>>>
>>> <snip>
>>>
>>> Simon's patch at http://marc.info/?l=linux-kernel&m=129649842110692&w=4
>>> fixes this problem, so feel free to add
>>>
>>> Tested-by: Chris Clayton <chris2553@googlemail.com>
>>>
>> I note that Simon's patch hasn't made it through to Linus yet. Which tree is ot 
>> going through, please?
> 
> Block tree.  Jens?

Hmm, I was pretty sure it was queued up in for-linus, but that does not
look like it's the case. I'll shove it in there, thanks!

-- 
Jens Axboe

