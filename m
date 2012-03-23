Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2CWDX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:23:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40992 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2CWDXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:23:25 -0400
Message-ID: <4F6BECA7.7030007@linaro.org>
Date: Thu, 22 Mar 2012 20:23:19 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com> <20120319130445.GN15988@n2100.arm.linux.org.uk> <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com> <20120319132623.GO15988@n2100.arm.linux.org.uk>	<4F696011.7080409@linaro.org> <CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com> <CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com> <20120322100236.GS15988@n2100.arm.linux.org.uk> <CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
In-Reply-To: <CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032303-7182-0000-0000-0000011A54A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 03:25 AM, Ajeet Yadav wrote:
> I understand your point,
> Our target (2.6) always had ARCH_USES_GETTIMEOFFSET=y , but still we
> were able to use the TRACER in past until the patch "kill
> GENERIC_TIMER" published, anyone will ask me remove this patch and use
> TRACER, becaue it was working before. :)

Ajeet,
     Sorry, by TRACER, do you mean PREEMPT_TRACER or something else? And 
what specific 2.6.X kernel were you using?

Steven, I'm seeing:
config PREEMPT_TRACER
         bool "Preemption-off Latency Tracer"
         default n
         depends on !ARCH_USES_GETTIMEOFFSET

Do you have any context as to why is !ARCH_USES_GETTIMEOFFSET flagged here?

thanks
-john

