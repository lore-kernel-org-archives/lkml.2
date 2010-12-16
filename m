Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0LPQzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:55:44 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:53099 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0LPQzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:55:39 -0500
X-ASG-Debug-ID: 1292518537-2c9d3a550001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D0A447E.8050802@fusionio.com>
Date: Thu, 16 Dec 2010 17:55:26 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Tejun Heo <tj@kernel.org>, <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <jack@suse.cz>, <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com> <4D0A4196.8040209@kernel.dk>
X-ASG-Orig-Subj: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
In-Reply-To: <4D0A4196.8040209@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292518537
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5000 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49610
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-16 17:43, Jens Axboe wrote:
> On 2010-12-16 17:41, Kay Sievers wrote:
>> On Thu, Dec 16, 2010 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2010-12-16 17:31, Tejun Heo wrote:
>>>> On 12/08/2010 08:57 PM, Tejun Heo wrote:
>>>>> This is the second take of in-kernel-disk-event patchset which
>>>>> implements in-kernel disk event handling framework and adds support
>>>>> for it to sr and sd.  This is largely to move media presence polling
>>>>> into kernel as userspace implementation turned out to be quite
>>>>> problematic over the years.
>>>>
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

Done. It's in for-2.6.38/event-handling, and for-next is update to have
the pending stuff for 2.6.38 in total.

-- 
Jens Axboe

