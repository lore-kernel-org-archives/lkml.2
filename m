Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0EGClc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:41:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44303 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0EGCla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:41:30 -0400
Message-ID: <4BE37DDD.8000402@cox.net>
Date: Thu, 06 May 2010 22:41:33 -0400
From: James Kosin <james.kosin.04@cnu.edu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
References: <eGToe-3b9-5@gated-at.bofh.it> <eGUaB-4mU-1@gated-at.bofh.it> <eGUtX-4Kd-3@gated-at.bofh.it> <eGWvL-7Fy-1@gated-at.bofh.it> <eGWFt-7S7-17@gated-at.bofh.it> <eGWP9-8jH-17@gated-at.bofh.it>
In-Reply-To: <eGWP9-8jH-17@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2010 8:10 PM, Tony Lindgren wrote:
> * Brian Swetland <swetland@google.com> [100505 16:51]:
>> On Wed, May 5, 2010 at 4:47 PM, Tony Lindgren <tony@atomide.com> wrote:
>>> * Brian Swetland <swetland@google.com> [100505 14:34]:
>>>> On Wed, May 5, 2010 at 2:12 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
<<-- snip -->>
>>>>> At no point does the user program have to communicate anything to the
>>>>> modem driver, and at no point does it have to do anything out of the
>>>>> ordinary except to enable and disable a suspend blocker.
>>>>
>>>> Exactly -- and you can use the same style of overlapping suspend
>>>> blockers with other drivers than input, if the input interface is not
>>>> suitable for the particular interaction.
>>>
>>> Would the suspend blockers still be needed somewhere in the example
>>> above?
>>
>> How often would we retry suspending?
> 
> Well based on some timer, the same way the screen blanks? Or five
> seconds of no audio play? So if the suspend fails, then reset whatever
> userspace suspend policy timers.
>  

Tony,
Wouldn't this be handled by the idle task, or task manager?

When all tasks are suspended and not doing anything that should be the
first clue that a real suspend cycle could be attempted.

James
