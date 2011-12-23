Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1LWM3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:29:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43413 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab1LWM3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:29:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh0hwNrOHVOx6eFf6EM8MmGwjeCP4-PfCHtMPnBQm4th91Q8Q@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<alpine.LRH.2.00.1112231047000.21599@twin.jikos.cz>
	<CAOh0hwPbV5=QU=bB6Atw5taGW8CN9r8UesE=ZhKrO+sRDY0_3A@mail.gmail.com>
	<CAOh0hwNrOHVOx6eFf6EM8MmGwjeCP4-PfCHtMPnBQm4th91Q8Q@mail.gmail.com>
Date: Fri, 23 Dec 2011 14:29:08 +0200
Message-ID: <CAMhs6Yyu2A-t-ZwksE8zUZygG68ReWtVZ+QjVL=8Z8bTdKWeLg@mail.gmail.com>
Subject: Re: Intercepting system calls
From: Maxin B John <maxin.john@gmail.com>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 23, 2011 at 1:59 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
> I found that Ubuntu does not have a kprobe enabled kernel. :( I don't
> think I could use kprobes then.

Probably you can find a solution using Systemtap.

Have a look at this example:
http://sourceware.org/systemtap/examples/general/badname.stp

It just needs some modifications to meet your needs.

HTH,
Maxin B. John

> On Fri, Dec 23, 2011 at 3:20 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
>> Hello Jiri
>>
>> On Fri, Dec 23, 2011 at 3:17 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>>> On Thu, 22 Dec 2011, Gaurav Saxena wrote:
>>>
>>>> I am writing an application for which I need to intercept some
>>>> filesystem system calls eg. unlink. I need unlink to call my code
>>>> before deleting abc so that I could probably prevent unlink . I would
>>>> like to implement this in a kernel module instead of modifying kernel
>>>> code itself. I would like to intercept system calls by replacing
>>>> system calls but I have not been able to find any method of doing that
>>>> in linux > 3.0. Please suggest some method of doing that.
>>>
>>> Write a kernel module that instruments sys_unlink() via krpobes. See
>>> Documentation/kprobes.txt for details.
>> Ok. I am looking at its details, will try that. But how could a probe
>> prevent execution of a system call?
>>>
>>> --
>>> Jiri Kosina
>>> SUSE Labs
>>>
>>
>>
>>
>> --
>> Thanks and Regards ,
>> Gaurav
>
>
>
> --
> Thanks and Regards ,
> Gaurav
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
