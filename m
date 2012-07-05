Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2GEOmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab2GEOmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:42:01 -0400
Message-ID: <4FF5A79E.9030703@redhat.com>
Date: Thu, 05 Jul 2012 10:41:34 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux@openhuawei.org
Subject: Re: [PATCH 0/3][RFC] Fix for leapsecond caused futex issue (v4)
References: <1341382890-42324-1-git-send-email-johnstul@us.ibm.com> <4FF3E178.7000806@us.ibm.com>
In-Reply-To: <4FF3E178.7000806@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/04/2012 02:23 AM, John Stultz wrote:
> On 07/03/2012 11:21 PM, John Stultz wrote:
>> Ok, made a few tweaks to address issues caught by Prarit's and my
>> testing. This has run for a number of hours now w/ my leap-a-day.c
>> test on a few machines.
>>
>> I'd really appreciate any extra testing, review, or acks at this point.
>> I'm targeting mid-late Thursday (to give folks in the US a chance to
>> review & test) as a point when I'll submit this upstream if no other
>> issues are found.
> 
> And again, here's my leap-a-day.c test case which can be used to trigger a
> leapsecond every day, or every ~13 seconds via the -s option.
> 

I tested this patchset for ~22 hours without any issues using my own leap second
test code, John's previous leaptest.c and this new leap-a-day test with and
without the -s option.

In all x86 systems' cases (both AMD and Intel, large cpu count[1] and small cpu
count) I also ran Firefox in the background and monitored it using top and
occasionally breaking in to check the status of the futexes.  I haven't seen
anything wrong with any of the systems.

John, my apologies for not getting to exactly 24 hours.  I've usurped these
systems long enough and other people need them :/.  I'm going to continue to run
two systems (one AMD and one Intel) for a longer stretch but I don't anticipate
any issues at this point.

So ...

Acked-by: Prarit Bhargava <prarit@redhat.com>

For the entire patchset.

P.
