Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2CWE7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:59:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62024 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2CWE7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:59:34 -0400
MIME-Version: 1.0
In-Reply-To: <4F6BECA7.7030007@linaro.org>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
	<CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	<CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	<20120322100236.GS15988@n2100.arm.linux.org.uk>
	<CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	<4F6BECA7.7030007@linaro.org>
Date: Fri, 23 Mar 2012 10:29:33 +0530
Message-ID: <CAB4K4y7zGex+1u-_PBVwVzHu6OYGQfL=Cv9aFfEG2_Q0-S-evA@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 8:53 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 03/22/2012 03:25 AM, Ajeet Yadav wrote:
>>
>> I understand your point,
>> Our target (2.6) always had ARCH_USES_GETTIMEOFFSET=y , but still we
>> were able to use the TRACER in past until the patch "kill
>> GENERIC_TIMER" published, anyone will ask me remove this patch and use
>> TRACER, becaue it was working before. :)
>
>
> Ajeet,
>    Sorry, by TRACER, do you mean PREEMPT_TRACER or something else? And what
> specific 2.6.X kernel were you using?
IRQSOFF_TRACER and PREEMPT_TRACER, our old kernel was 2.6.35.
>
> Steven, I'm seeing:
>
> config PREEMPT_TRACER
>        bool "Preemption-off Latency Tracer"
>        default n
>        depends on !ARCH_USES_GETTIMEOFFSET
>
> Do you have any context as to why is !ARCH_USES_GETTIMEOFFSET flagged here?
>
> thanks
> -john
>
