Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0LUHiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:38:19 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:35234 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0LUHiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:38:18 -0500
X-ASG-Debug-ID: 1292917096-0f2733fa0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D105963.7030509@fusionio.com>
Date: Tue, 21 Dec 2010 08:38:11 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        <akpm@linux-foundation.org>, <smcameron@yahoo.com>,
        <linux-kernel@vger.kernel.org>, <mike.miller@hp.com>,
        <thenzl@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cciss: fix cciss_revalidate panic.
References: <20101216190200.630.8596.stgit@beardog.cce.hp.com> <4D0B190E.1030206@kernel.dk> <20101220234213.GA10060@sepie.suse.cz> <4D105858.2020209@kernel.dk>
X-ASG-Orig-Subj: Re: [PATCH] cciss: fix cciss_revalidate panic.
In-Reply-To: <4D105858.2020209@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292917096
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.50054
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-21 08:33, Jens Axboe wrote:
> On 2010-12-21 00:42, Michal Marek wrote:
>> On Fri, Dec 17, 2010 at 09:02:22AM +0100, Jens Axboe wrote:
>>> On 2010-12-16 20:02, Stephen M. Cameron wrote:
>>>> From: Stephen M. Cameron <StephenM.Cameron>
>>>>
>>>> If you delete a logical drive, and then run BLKRRPART (e.g. via fdisk)
>>>> on a logical drive which is "after" the deleted logical drive in the h->drv[]
>>>> array, then cciss_revalidate panics because it will access the null pointer
>>>> h->drv[x] when x hits the deleted drive.
>>>
>>> Thanks Stephen. I put this in for-linus for 2.6.37 and marked it for
>>> stable backport.
>>
>> This got applied without the semicolon after 'continue' somehow and
>> broke build. Please apply the patch below.
> 
> I wonder how that happened. Thanks, I'll fix it up.

Linus already did I see.

-- 
Jens Axboe

