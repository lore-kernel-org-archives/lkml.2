Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2CVKCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:02:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49190 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab2CVKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:02:47 -0400
Date: Thu, 22 Mar 2012 10:02:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
Message-ID: <20120322100236.GS15988@n2100.arm.linux.org.uk>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com> <20120319130445.GN15988@n2100.arm.linux.org.uk> <CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com> <20120319132623.GO15988@n2100.arm.linux.org.uk> <4F696011.7080409@linaro.org> <CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com> <CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:46:31PM +0530, Ajeet Yadav wrote:
> Hi John,
> On our target  ARCH_USES_GETTIMEOFFSET=y, can you please help me how
> can I useIRQSOFF_TRACER, PREEMPT_TRACER ?

If you have ARCH_USES_GETTIMEOFFSET=y, the simple answer is: you can't.

Your solution is to update your platform to use clock sources and clock
events and disable the obsolete ARCH_USES_GETTIMEOFFSET option.
