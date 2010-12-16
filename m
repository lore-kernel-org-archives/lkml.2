Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0LPQp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:45:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:54482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab0LPQpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:45:54 -0500
Message-ID: <4D0A4231.2070402@kernel.org>
Date: Thu, 16 Dec 2010 17:45:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, jack@suse.cz,
        James.Bottomley@hansenpartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com> <4D0A4196.8040209@kernel.dk>
In-Reply-To: <4D0A4196.8040209@kernel.dk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 16:45:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/16/2010 05:43 PM, Jens Axboe wrote:
>>>> Kay, Jens, James, how does this look to you guys?
>>>
>>> I like the concept, this is probably what we should have done all along.
>>> The user space method has been tried and failed. So I was mostly laying
>>> it low waiting for feedback before integrating this.
>>
>> Yeah, it's nice stuff. Userspace works, but can not be made entirely
>> safe. We have (rare) bugs we just can not fix otherwise than disabling
>> polling.
>>
>>> Kay?
>>
>> I want it! :)
>>
>> If you merge it, let me know when you have a tree ready, so I can test
>> the most recent version again.
> 
> OK good, looks like we all agree... I'll queue it up in for-2.6.38
> branch and update for-next to have all that stuff.

Heh, that was fast.  Anyways, James, it would be great if you can take
a look at the sr/sd changes.  I think they're correct but that's kinda
expected, so... :-)

-- 
tejun
