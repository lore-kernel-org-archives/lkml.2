Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893Ab2EJRin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:38:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34496 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760649Ab2EJRih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205092122140.21030@xanadu.home>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
 <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
 <20120509122436.1b612004.akpm@linux-foundation.org> <201205092038.16722.arnd.bergmann@linaro.org>
 <CAK5ve-Ko6EjZsJBW++ofL0eHxiR5W+wafb3T99Rm9a1L8pHLBQ@mail.gmail.com>
 <CAOesGMhioLshtsYiHCdQxtx7+3GJsCyhgd7c7nDiZC3=3axb6w@mail.gmail.com>
 <CAK5ve-+rCv3s+K6Laie=QaPqqZ4Vk1+irYU6S4MBZSquKrMWtw@mail.gmail.com> <alpine.LFD.2.02.1205092122140.21030@xanadu.home>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 11 May 2012 01:38:16 +0800
X-Google-Sender-Auth: 8NgJvNzeueD3WUO9_1KMitUDHaM
Message-ID: <CAK5ve-JC61jFX7+GV9VoZKExbtdxX03jmpkzu5zxHg+Lehy7VQ@mail.gmail.com>
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

On Thu, May 10, 2012 at 9:25 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 10 May 2012, Bryan Wu wrote:
>
>> On Thu, May 10, 2012 at 7:47 AM, Olof Johansson <olof@lixom.net> wrote:
>> > On Wed, May 9, 2012 at 4:41 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>> >> On Thu, May 10, 2012 at 4:38 AM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
>> >>> On Wednesday 09 May 2012, Andrew Morton wrote:
>> >>>> I'm the LEDs patchmonkey at present.  I can merge the drivers/leds
>> >>>> change if you like, but there doesn't seem much point in that unless
>> >>>> all the other patches get merged.
>> >>>>
>> >>>> So my preferred approach would be for the patch series to get merged
>> >>>> via some ARM tree.
>> >>>
>> >>> I'm fine with taking it through arm-soc if that helps.
>> >>
>> >> That would be great to merge from arm-soc tree, thanks a lot, Arnd and Andrew.
>> >
>> > Ok, cool. Do you want to stage a branch in a git repo that we pull, or
>> > do you prefer that we pick up the patches as posted? It's easier for
>> > us to just do a pull but either way is fine.
>> >
>>
>> Great, I've already put in my kernel tree
>>
>> Please find these patches here:
>>       git://kernel.ubuntu.com/roc/linux-2.6/.git leds
>
> You applied your patches on top of linux-next.  This can't be merged
> upstream until you rebase your patches on something stable such as pure
> v3.4-rc6 for example.
>

Got it, Nico. As I'm still in US for our Ubuntu Developer Summit, I
plan to rebase and test on my hardware after I'm back to home next
week.

Thanks,
-Bryan



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
