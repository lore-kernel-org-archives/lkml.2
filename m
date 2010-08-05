Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab0HEIxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:53:13 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:37638 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab0HEIxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:53:09 -0400
Message-ID: <4C5A7B93.9020106@stericsson.com>
Date: Thu, 5 Aug 2010 10:51:31 +0200
From: Philippe Langlais <philippe.langlais@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] U6715 16550A serial driver support
References: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com>	<20100804125253.3977b0d7.akpm@linux-foundation.org>	<4C5A64E0.5060807@stericsson.com> <20100805002206.758777aa.akpm@linux-foundation.org>
In-Reply-To: <20100805002206.758777aa.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/05/10 09:22, Andrew Morton wrote:
> On Thu, 5 Aug 2010 09:14:40 +0200 Philippe Langlais<philippe.langlais@stericsson.com>  wrote:
>
>    
>>      
>>>>
>>>>          
>>> The patch adds these .set_termios hooks but doesn't actually use them
>>> for anything.
>>>
>>> The changelog doesn't tell us _why_ this was done (it should) and
>>> lacking any code to look at it's all a bit mysterious.
>>>
>>>
>>>        
>> This feature is used in our U6715 8250 platform serial driver, to avoid
>> hack in 8250.c set_termios (Alan Cox requirement).
>> In this driver the input uart clock frequency depends on baud rate and
>> is computed in our set_termios override function.
>> The U6715 paltform serial patch has been submitted on linux-arm mailing
>> list,
>> and is ready to enter Russell King Linux tree.
>>      
> Oh.
>
>    
>> More things to do ?
>>      
> Update the changelog to include this rather important information.
>    
Ok is done
> As the patches are dependent, treat them as a single series.  Russell
> can merge them both with Greg's ack or Greg can merge them both with
> Russell's ack.
>
>    
This patch can be merged before U6715 platform one without problem.
Where I post the series in linux-kernel or linux-arm or both mailing lists ?
Greg has already taken this patch in its linux-next tree, need to resend 
to him the patch with new comments ?
All U6715 platform patches are already posted in linux-arm mailing list.
It's my first contribution and I don't know how to proceed.

Thanks
Philippe
