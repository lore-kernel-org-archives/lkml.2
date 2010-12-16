Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0LPRAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:00:19 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35444 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab0LPRAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:00:16 -0500
Message-ID: <4D0A4594.6030704@kernel.dk>
Date: Thu, 16 Dec 2010 18:00:04 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, jack@suse.cz,
        James.Bottomley@hansenpartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
  take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com> <4D0A4196.8040209@kernel.dk> <4D0A4231.2070402@kernel.org>
In-Reply-To: <4D0A4231.2070402@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-16 17:45, Tejun Heo wrote:
> Hello,
> 
> On 12/16/2010 05:43 PM, Jens Axboe wrote:
>>>>> Kay, Jens, James, how does this look to you guys?
>>>>
>>>> I like the concept, this is probably what we should have done all along.
>>>> The user space method has been tried and failed. So I was mostly laying
>>>> it low waiting for feedback before integrating this.
>>>
>>> Yeah, it's nice stuff. Userspace works, but can not be made entirely
>>> safe. We have (rare) bugs we just can not fix otherwise than disabling
>>> polling.
>>>
>>>> Kay?
>>>
>>> I want it! :)
>>>
>>> If you merge it, let me know when you have a tree ready, so I can test
>>> the most recent version again.
>>
>> OK good, looks like we all agree... I'll queue it up in for-2.6.38
>> branch and update for-next to have all that stuff.
> 
> Heh, that was fast.  Anyways, James, it would be great if you can take
> a look at the sr/sd changes.  I think they're correct but that's kinda
> expected, so... :-)

One thing I noticed is that cdrom_check_events() needs an export.

-- 
Jens Axboe

