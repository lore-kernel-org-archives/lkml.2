Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab2LQFmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 00:42:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64746 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2LQFmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 00:42:45 -0500
Date: Sun, 16 Dec 2012 21:42:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and
 clk_disable_unprepare()
Message-ID: <20121217054240.GA13300@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
 <20121216115756.GO14363@n2100.arm.linux.org.uk>
 <CAKohpok7Lh_ozuBFZdObpPRj0u_B-MNqgWjmaaSik3v4SmgJcw@mail.gmail.com>
 <20121216124013.GP14363@n2100.arm.linux.org.uk>
 <CAKohpom37Liqhz38YthaL9q+iFh4=iYHoUmrTOMq2=Ut-D0Dhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpom37Liqhz38YthaL9q+iFh4=iYHoUmrTOMq2=Ut-D0Dhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Sun, Dec 16, 2012 at 06:35:24PM +0530, Viresh Kumar wrote:
> On 16 December 2012 18:10, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Well, there's my comment against patch 2 which never got a reply:
> >
> > "Again, what about stuff not using drivers/clk/clk.c ?"
> >
> > Has this been addressed?
> 
> Hmm.. I misread it and thought it is same as breaking other platforms
> because there are
> no dummy routines. But i was wrong :(
> 
> So, the problem is, platform not using common-clock framework uses
> this routine, and they
> don't want it to be dummy but call prepare & enable..
> 
> Because Dmirty requires this one to be non-inline, either he can move
> these routines to
> drivers/clk/clk-devres.c (which would be wrong) or can add wrappers
> over them in clk-devres
> file.

They do not _have_ to be non-inline, I think we should simply drop the
first 2 patches and I will refresh and ressend the 3rd one.

Thanks.

-- 
Dmitry
