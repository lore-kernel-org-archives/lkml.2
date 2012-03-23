Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2CWD2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:28:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37728 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2CWD2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:28:09 -0400
Message-ID: <4F6BEDC1.60006@linaro.org>
Date: Thu, 22 Mar 2012 20:28:01 -0700
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
x-cbid: 12032303-7282-0000-0000-000007997E07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 03:25 AM, Ajeet Yadav wrote:
> If I set  ARCH_USES_GETTIMEOFFSET=n to use this feature, my target
> fail to boot. (reason I well understand from our past discussions)
And this point I'm not sure I'm following. Why exactly does disabling 
ARCH_USES_GETTIMEOFFSET cause boot failures? Could you expand on the 
details here?

You should just end up using the jiffies clocksource, which would give 
you low-res HZ granular timestamps, but shouldn't get in the way of booting.

thanks
-john

