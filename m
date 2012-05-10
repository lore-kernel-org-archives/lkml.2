Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709Ab2EJSLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:11:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760433Ab2EJSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:11:46 -0400
Date: Thu, 10 May 2012 11:11:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Bryan Wu <bryan.wu@canonical.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, tim.gardner@canonical.com
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
Message-Id: <20120510111143.2edb3bc8.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1205101351380.21030@xanadu.home>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
	<CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
	<20120509122436.1b612004.akpm@linux-foundation.org>
	<201205092038.16722.arnd.bergmann@linaro.org>
	<CAK5ve-Ko6EjZsJBW++ofL0eHxiR5W+wafb3T99Rm9a1L8pHLBQ@mail.gmail.com>
	<CAOesGMhioLshtsYiHCdQxtx7+3GJsCyhgd7c7nDiZC3=3axb6w@mail.gmail.com>
	<CAK5ve-+rCv3s+K6Laie=QaPqqZ4Vk1+irYU6S4MBZSquKrMWtw@mail.gmail.com>
	<alpine.LFD.2.02.1205092122140.21030@xanadu.home>
	<CAK5ve-JC61jFX7+GV9VoZKExbtdxX03jmpkzu5zxHg+Lehy7VQ@mail.gmail.com>
	<alpine.LFD.2.02.1205101351380.21030@xanadu.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 14:01:35 -0400 (EDT)
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

> On Fri, 11 May 2012, Bryan Wu wrote:
> 
> > On Thu, May 10, 2012 at 9:25 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > > You applied your patches on top of linux-next. __This can't be merged
> > > upstream until you rebase your patches on something stable such as pure
> > > v3.4-rc6 for example.
> > >
> > 
> > Got it, Nico. As I'm still in US for our Ubuntu Developer Summit, I
> > plan to rebase and test on my hardware after I'm back to home next
> > week.
> 
> Given where things are, you risk being too late for this merge window if 
> you do so, meaning that this cleanup will have to wait yet another 
> cycle which would be rather disappointing.

Well, there hasn't been an open merge window for over a month. 
Cleanups and features should be scheduled for 3.5-rc1.


