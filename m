Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440Ab2EJARj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:17:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41578 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab2EJARi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <1336607530.2494.111.camel@ted>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
 <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
 <20120509122436.1b612004.akpm@linux-foundation.org> <201205092038.16722.arnd.bergmann@linaro.org>
 <CAK5ve-Ko6EjZsJBW++ofL0eHxiR5W+wafb3T99Rm9a1L8pHLBQ@mail.gmail.com> <1336607530.2494.111.camel@ted>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 10 May 2012 08:17:17 +0800
X-Google-Sender-Auth: jaUi3Wmb0p2Aj0YZEVLKHvd2rzU
Message-ID: <CAK5ve-Lu+RhY2vj7EnsgLNt8_wMEt_X66c8nHYDPbd2YJ28bcQ@mail.gmail.com>
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 7:52 AM, Richard Purdie <rpurdie@rpsys.net> wrote:
> On Thu, 2012-05-10 at 07:41 +0800, Bryan Wu wrote:
>> On Thu, May 10, 2012 at 4:38 AM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
>> > On Wednesday 09 May 2012, Andrew Morton wrote:
>> >> I'm the LEDs patchmonkey at present.  I can merge the drivers/leds
>> >> change if you like, but there doesn't seem much point in that unless
>> >> all the other patches get merged.
>> >>
>> >> So my preferred approach would be for the patch series to get merged
>> >> via some ARM tree.
>> >
>> > I'm fine with taking it through arm-soc if that helps.
>>
>> That would be great to merge from arm-soc tree, thanks a lot, Arnd and Andrew.
>>
>> > In the long run,
>> > it would be nice to have a proper maintainer for this again after Richard
>> > more or less stepped down from that position. Given that Bryan has shown
>> > that he's persistent enough to get this patch series to v9, how about
>> > making him the primary maintainer for the entire subsystem? He should
>> > know a lot about it already. Bryan?
>> >
>>
>> I do love to start to do more contribution and maintain the
>> drivers/leds subsystem with Richard's help, if Richard is fine with
>> this, I can send out patch to add a MAINTAINER entry.
>
> I'm ok with that, I'm also happy to stay involved at a distance. I do
> read emails and try and help where I can :). I'm just not doing day to
> day rebuilds of cutting edge kernels so the patch work isn't something
> I've been able to find time for and the Yocto Project is where my main
> focus appears best placed at the moment.
>

Thanks, Richard, I really appreciate your help here
-Bryan
