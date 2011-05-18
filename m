Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1ERCHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:07:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42262 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab1ERCHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dD0L3qjqB6jIWlELAumJmeIByT1SCowN1AEDWn1LRr/ihBVV5N5Q9MMMyXnN5CprPs
         si3COXHb0FdpQoOawZVcOQrET3okmNwdrXfvmvFsHX0pOCOSkmX4mQbAJmuVpriI7Atz
         2p52nDNALvBbW2CwNk9w80xP2qXxHKBCPcAeo=
MIME-Version: 1.0
In-Reply-To: <BANLkTimgmam0_yg+5a58T3R_NYM6RQLakQ@mail.gmail.com>
References: <BANLkTikqKnQgyLr0OmL86iEHE95xB4Z50Q@mail.gmail.com>
	<BANLkTim=di8pbt1CzHjHYSC0SbtgJzbmkw@mail.gmail.com>
	<BANLkTimgmam0_yg+5a58T3R_NYM6RQLakQ@mail.gmail.com>
Date: Wed, 18 May 2011 10:07:21 +0800
Message-ID: <BANLkTin6RruD=M5=HVZ6UeqovUZwibS+pQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix priority leakage in pick_next_highest_task_rt()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:53 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Tue, May 17, 2011 at 10:28 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> On Mon, May 16, 2011 at 8:55 PM, Hillf Danton <dhillf@gmail.com> wrote:
>>> When picking the second highest RT task for a given runqueue, if no
>>> task found after scanning the queue of priority == idx, the next idx
>>> should also be checked even in case that next is already existing, or
>>> the window of priority leakage could be opened.
>>
>> I don't see what kind of problem you patch will fix.
>> And mind explaining how priority leakage could happen?
>>
> Hi Yong
>
> If no task is found after scanning the list at array->queue + idx,
> what should we operate on next?
> And why is the list scanned?

Hmmm, I get your point.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

Thanks,
Yong



-- 
Only stand for myself
