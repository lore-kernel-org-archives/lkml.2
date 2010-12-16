Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0LPQmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:42:01 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:42094 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0LPQl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <4D0A400F.5090608@kernel.dk>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 16 Dec 2010 17:41:42 +0100
Message-ID: <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling, take#2
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz,
        James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
> On 2010-12-16 17:31, Tejun Heo wrote:
>> On 12/08/2010 08:57 PM, Tejun Heo wrote:
>>> This is the second take of in-kernel-disk-event patchset which
>>> implements in-kernel disk event handling framework and adds support
>>> for it to sr and sd.  This is largely to move media presence polling
>>> into kernel as userspace implementation turned out to be quite
>>> problematic over the years.
>>
>> Kay, Jens, James, how does this look to you guys?
>
> I like the concept, this is probably what we should have done all along.
> The user space method has been tried and failed. So I was mostly laying
> it low waiting for feedback before integrating this.

Yeah, it's nice stuff. Userspace works, but can not be made entirely
safe. We have (rare) bugs we just can not fix otherwise than disabling
polling.

> Kay?

I want it! :)

If you merge it, let me know when you have a tree ready, so I can test
the most recent version again.

Thanks,
Kay
