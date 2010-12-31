Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0LaT4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:56:39 -0500
Received: from smtp4.Stanford.EDU ([171.67.219.84]:43851 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882Ab0LaT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:56:38 -0500
Message-ID: <4D1E3572.20505@localhost>
Date: Fri, 31 Dec 2010 11:56:34 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 2.6.33.7-rt29
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain> <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain> <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain> <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain> <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain> <alpine.LFD.2.00.1007311530510.2471@localhost.localdomain> <alpine.LFD.2.00.1008031118270.3225@localhost.localdomain> <alpine.LFD.2.00.1012211437120.12146@localhost6.localdomain6> <4D152086.1070909@localhost>
In-Reply-To: <4D152086.1070909@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2010 02:36 PM, Fernando Lopez-Lezcano wrote:
> On 12/21/2010 05:52 AM, Thomas Gleixner wrote:
>> We are pleased to announce the next update to our new preempt-rt
>> series.
>> ...
>> Information on the RT patch can be found at:
>>
>> http://rt.wiki.kernel.org/index.php/Main_Page
>>
>> To build the 2.6.33.7.2-rt30 tree, the following patches should be
>> applied:
>>
>> http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.7.tar.bz2
>> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.7.2-rt30.bz2
>>
>>
>> Enjoy !
>
> I'm testing it right now and it does seem to have fixed some stuff, for
> example I don't see any more errors when waking up from a sleep state.
> Anyway, I'll let you know of any problems...

So far so good...

> Thanks a lot! (and also good to know about the plans for 2.6.37.x rt!)

A question: I need to find out the pid of the irq process that handles a 
particular audio device from the information available from udev (to 
dynamically change its rt priority).

AFAICT that is not really possible. I can find the irq number easily but 
if there is more than one device using that number then I'm sort of 
stuck. The naming of the irq processes for each card appear to be 
hardwired strings in the driver code that do not necessarily correspond 
to any other name in the driver itself.

Is there a connection between the two somewhere in /sys, /proc or 
anywhere else that I'm missing? (ie: which interrupt process corresponds 
to which driver?)

-- Fernando
