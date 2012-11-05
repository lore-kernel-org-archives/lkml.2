Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2KEIem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:34:42 -0500
Received: from smtp.getmail.no ([84.208.15.66]:43160 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab2KEIel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:34:41 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Lukasz Sokol <el.es.cr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The uncatchable jitter, or may the scheduler wars be over?
References: <loom.20121005T132825-464@post.gmane.org>
 <op.wm85dbb76426ze@localhost.localdomain>
 <CAEwFKRCDbxbODSP917ZvNXGYzW2iuipaiD4cFkTuQQvsMeMkeQ@mail.gmail.com>
Date: Mon, 05 Nov 2012 09:34:38 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
Message-id: <op.wnakr0qk1c32bs@localhost.localdomain>
In-reply-to: <CAEwFKRCDbxbODSP917ZvNXGYzW2iuipaiD4cFkTuQQvsMeMkeQ@mail.gmail.com>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2012 18:03:58 +0100, Lukasz Sokol <el.es.cr@gmail.com>  
wrote:

> A word of addition,
>
> On Sun, Nov 4, 2012 at 2:04 PM, Uwaysi Bin Kareem
> <uwaysi.bin.kareem@paradoxuncreated.com> wrote:
> [snip]
>>
>> Also like I stated elsewhere, since daemons seem to make a difference,
>> optimally putting daemons or processes that can, on a low-jitter queue,
>> transparent to the user, seems optimal. Unfortunately realtime is not  
>> quite
>> working as one would expect, causing input to be choked at times, if you
>> want to have one main app, and the rest on sched_other, as a low-jitter
>> queue. So I am still iterating this.
>
> Hard real time kernel, will make the situation even worse: there the  
> userspace
> will get preempted always and no matter what it is doing; RT means here,
> the userspace will /get/ the slice, but whether the slice will be  
> enough, no one
> can guarantee but whoever wrote the userspace.
> It's the userspace that must decide 'do I have enough time to run
> another rendering loop within
> this time slice (or before vsync is imminent)'.
>
> (As in: real time is not 'as fast as possible' but 'as fast as
> specified' and the specification
> need to be within reason).
>
>>
> [snip]
>> Peace Be With You.
>
> Lukasz

I meant realtime-thread here, not added preemption points, for  
realtime-behaviour.
But I understand your point. So "low-jitter" is ofcourse the sweetspot,  
where you have just enough interrupts and preemption points, for exactly  
that, but not too much.

Peace Be With You.
 
