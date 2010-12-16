Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0LPQnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:43:13 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53018 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0LPQnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:43:11 -0500
Message-ID: <4D0A4196.8040209@kernel.dk>
Date: Thu, 16 Dec 2010 17:43:02 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz,
        James.Bottomley@hansenpartnership.com
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com>
In-Reply-To: <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-16 17:41, Kay Sievers wrote:
> On Thu, Dec 16, 2010 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2010-12-16 17:31, Tejun Heo wrote:
>>> On 12/08/2010 08:57 PM, Tejun Heo wrote:
>>>> This is the second take of in-kernel-disk-event patchset which
>>>> implements in-kernel disk event handling framework and adds support
>>>> for it to sr and sd.  This is largely to move media presence polling
>>>> into kernel as userspace implementation turned out to be quite
>>>> problematic over the years.
>>>
>>> Kay, Jens, James, how does this look to you guys?
>>
>> I like the concept, this is probably what we should have done all along.
>> The user space method has been tried and failed. So I was mostly laying
>> it low waiting for feedback before integrating this.
> 
> Yeah, it's nice stuff. Userspace works, but can not be made entirely
> safe. We have (rare) bugs we just can not fix otherwise than disabling
> polling.
> 
>> Kay?
> 
> I want it! :)
> 
> If you merge it, let me know when you have a tree ready, so I can test
> the most recent version again.

OK good, looks like we all agree... I'll queue it up in for-2.6.38
branch and update for-next to have all that stuff.

-- 
Jens Axboe

