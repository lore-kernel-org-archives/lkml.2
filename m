Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945Ab2EJSBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:01:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34278 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab2EJSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:01:39 -0400
Date: Thu, 10 May 2012 14:01:35 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>
cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, tim.gardner@canonical.com
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
In-Reply-To: <CAK5ve-JC61jFX7+GV9VoZKExbtdxX03jmpkzu5zxHg+Lehy7VQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1205101351380.21030@xanadu.home>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com> <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com> <20120509122436.1b612004.akpm@linux-foundation.org> <201205092038.16722.arnd.bergmann@linaro.org>
 <CAK5ve-Ko6EjZsJBW++ofL0eHxiR5W+wafb3T99Rm9a1L8pHLBQ@mail.gmail.com> <CAOesGMhioLshtsYiHCdQxtx7+3GJsCyhgd7c7nDiZC3=3axb6w@mail.gmail.com> <CAK5ve-+rCv3s+K6Laie=QaPqqZ4Vk1+irYU6S4MBZSquKrMWtw@mail.gmail.com> <alpine.LFD.2.02.1205092122140.21030@xanadu.home>
 <CAK5ve-JC61jFX7+GV9VoZKExbtdxX03jmpkzu5zxHg+Lehy7VQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-220378756-1336672897=:21030"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-220378756-1336672897=:21030
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 11 May 2012, Bryan Wu wrote:

> On Thu, May 10, 2012 at 9:25 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > You applied your patches on top of linux-next.  This can't be merged
> > upstream until you rebase your patches on something stable such as pure
> > v3.4-rc6 for example.
> >
> 
> Got it, Nico. As I'm still in US for our Ubuntu Developer Summit, I
> plan to rebase and test on my hardware after I'm back to home next
> week.

Given where things are, you risk being too late for this merge window if 
you do so, meaning that this cleanup will have to wait yet another 
cycle which would be rather disappointing.

Given that the probabilities for something to break are rather small if 
you simply rebase on top of v3.4-rc6 from linux-next, I'd suggest you do 
the rebase ASAP and perform compilation tests only.  If this can be 
merged in the arm-soc tree quickly then this will get some exposure and 
actual testing from others which should be fine.


Nicolas
--8323328-220378756-1336672897=:21030--
