Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2CWI6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:58:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58135 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab2CWI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAH+eYFC7rTTKAtymLe1RWp_L-Sc1WGNueiLdCTwgVEkaNZFGUw@mail.gmail.com>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
	<CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	<CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	<20120322100236.GS15988@n2100.arm.linux.org.uk>
	<CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	<4F6BEDC1.60006@linaro.org>
	<CAB4K4y6u_59XLCBL2k5TrpAGv9C161wyqE_0_CEGbmgWeEwCyw@mail.gmail.com>
	<CAH+eYFC7rTTKAtymLe1RWp_L-Sc1WGNueiLdCTwgVEkaNZFGUw@mail.gmail.com>
Date: Fri, 23 Mar 2012 14:28:15 +0530
Message-ID: <CAB4K4y6s7ON4xn3LLM4TDmTZfAuCwieTkt4qDJ4qWp2Pw+UzpA@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 11:47 AM, Rabin Vincent <rabin@rab.in> wrote:
> On Fri, Mar 23, 2012 at 11:22, Ajeet Yadav <ajeet.yadav.77@gmail.com> wrote:
>> We did some dissection to narrow down the patch, our latest kernel is
>> stable 3.0.X , however we backported patch " ARM: 7321/1: cache-v7:
>> Disable preemption when reading CCSIDR" from 3.0.25 stable tree, this
>> patch causes kernel hang during boot (IRQSOFF_TRACER=y and
>> PREEMPT_TRACER=y) with 100% probability , if we remove this patch or
>> disable the given CONFIG's then boot is success.
>
> 8e43a905dd574f54c5715d9783 ("ARM: 7325/1: fix v7 boot with lockdep
> enabled") fixes 7321/1's boot problems.
Hi Rabin,
Thanks for fixing the boot problem, we have tested it, fixed.
