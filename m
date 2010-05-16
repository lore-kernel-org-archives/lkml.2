Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0EPQyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:54:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55743 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0EPQyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:54:21 -0400
Message-ID: <4BF02267.3000705@vflare.org>
Date: Sun, 16 May 2010 22:20:47 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramzswap: Remove backing swap support
References: <1273740861-1900-1-git-send-email-ngupta@vflare.org> <AANLkTilmMKWbnVjbSIp-owEG1wUsARdg8SvpoEjJNUJY@mail.gmail.com> <4BF012B2.6080602@vflare.org> <20100516162150.GA12062@kroah.com>
In-Reply-To: <20100516162150.GA12062@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 09:51 PM, Greg KH wrote:
> On Sun, May 16, 2010 at 09:13:46PM +0530, Nitin Gupta wrote:
>> Hi Minchan,
>>
>> On 05/16/2010 09:50 AM, Minchan Kim wrote:
>>  
>>> One thing was about naming.
>>> Now block device operations has field naming swap_xxx_notify
>>> (I am not sure exact name). My concern was it's very specific about swap.
>>> So I thought we would be better to more abstract name.
>>>
>>> I thought trim like naming as Linus said.
>>
>> This call is very swap specific and is quite different from generic trim
>> stuff. So, I think it will be better not be generalize the name and avoid
>> confusing it with trim/discard etc.
>>
>>>
>>> Anyway, I will review again at next week if it isn't merged
>>> linux-next(or linux-mm ?? which is right?). That's because I have a
>>> interest in your good ramzswap. :)
>>>
>>
>> Thanks, comments/reviews are always welcome :)
>>
>> Greg: In the meantime, considering 3 Acks, is it possible to pull it in
>> linux-next?
> 
> It's already there, right?
> 

Yuk! its there.

I actually wanted to refer to the 'swap notify patch'. Please see patch titled:
'ramzswap: Eliminate stale data from compressed memory (v2)'
(http://thread.gmane.org/gmane.linux.kernel/982232)

This patch got 3 Acks: Pekka, Linus and Nigel.

(Minchan, please always reply to the patch your are referring to)

Thanks,
Nitin


