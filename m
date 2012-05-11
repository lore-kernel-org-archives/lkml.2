Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2EKXMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:12:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63741 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2EKXL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:11:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205101351380.21030@xanadu.home>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
 <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
 <20120509122436.1b612004.akpm@linux-foundation.org> <201205092038.16722.arnd.bergmann@linaro.org>
 <CAK5ve-Ko6EjZsJBW++ofL0eHxiR5W+wafb3T99Rm9a1L8pHLBQ@mail.gmail.com>
 <CAOesGMhioLshtsYiHCdQxtx7+3GJsCyhgd7c7nDiZC3=3axb6w@mail.gmail.com>
 <CAK5ve-+rCv3s+K6Laie=QaPqqZ4Vk1+irYU6S4MBZSquKrMWtw@mail.gmail.com>
 <alpine.LFD.2.02.1205092122140.21030@xanadu.home> <CAK5ve-JC61jFX7+GV9VoZKExbtdxX03jmpkzu5zxHg+Lehy7VQ@mail.gmail.com>
 <alpine.LFD.2.02.1205101351380.21030@xanadu.home>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Sat, 12 May 2012 07:11:36 +0800
X-Google-Sender-Auth: c3o3LlBSW7ePw2UjNVNvq4cgdEM
Message-ID: <CAK5ve-L4rcAx-=n5u7G0AQzvUG3ir_jzF_ibaSf-EntXAzFUCw@mail.gmail.com>
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 2:01 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Fri, 11 May 2012, Bryan Wu wrote:
>
>> On Thu, May 10, 2012 at 9:25 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>> > You applied your patches on top of linux-next.  This can't be merged
>> > upstream until you rebase your patches on something stable such as pure
>> > v3.4-rc6 for example.
>> >
>>
>> Got it, Nico. As I'm still in US for our Ubuntu Developer Summit, I
>> plan to rebase and test on my hardware after I'm back to home next
>> week.
>
> Given where things are, you risk being too late for this merge window if
> you do so, meaning that this cleanup will have to wait yet another
> cycle which would be rather disappointing.
>
> Given that the probabilities for something to break are rather small if
> you simply rebase on top of v3.4-rc6 from linux-next, I'd suggest you do
> the rebase ASAP and perform compilation tests only.  If this can be
> merged in the arm-soc tree quickly then this will get some exposure and
> actual testing from others which should be fine.
>
>

OK, I rebased my patch back on 3.4.0-rc6, please find it here:
git://kernel.ubuntu.com/roc/linux-2.6/.git leds

linux-next branch can be also found here:
git://kernel.ubuntu.com/roc/linux-2.6/.git leds-next

Arnd, could you please help me to merge? if got any issue, please
point to me to fix.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
