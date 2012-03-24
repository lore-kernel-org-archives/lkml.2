Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2CXHFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:05:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60691 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2CXHFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120323161451.GA17509@kroah.com>
References: <20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
	<CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	<CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	<20120322100236.GS15988@n2100.arm.linux.org.uk>
	<CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	<4F6BEDC1.60006@linaro.org>
	<CAB4K4y6u_59XLCBL2k5TrpAGv9C161wyqE_0_CEGbmgWeEwCyw@mail.gmail.com>
	<20120323161451.GA17509@kroah.com>
Date: Sat, 24 Mar 2012 12:35:12 +0530
Message-ID: <CAB4K4y5sobJbsV63yOE8iAU_xE1_mpeQdtH7b1a6hD4UZL1mjA@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I send earlier reply using my andriod gmail application, and it was
rejected by stable/ linux-kernel (not in plain text), so sending again
using PC.

On Fri, Mar 23, 2012 at 9:44 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Mar 23, 2012 at 11:22:46AM +0530, Ajeet Yadav wrote:
>> CCing to stable@vger.kernel.org
>
> Why?  What am I supposed to do here?
>
> confused,
>
> greg k-h
I initially thought that problem is in 3.0.x stable, but I was wrong.
Solution patch suggested by Rabin is already there in stable.
Summary:
" ARM: 7321/1: cache-v7: > Disable preemption when reading CCSIDR"
introduce hang on boot, that is resolved by commit

"ARM: 7325/1: fix v7 boot with lockdep enabled"
 fortunately both are in 3.0.x so no problem,

but i do not know about other stable versions.
