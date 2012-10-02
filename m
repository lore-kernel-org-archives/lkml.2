Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2JBM5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:57:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40260 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2JBM5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <201210021152.30099.arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
	<1348868177-21205-12-git-send-email-arnd@arndb.de>
	<CACRpkdZv2b8M2Y4BJpqOX72prLHf4aACbmYk=imevX7h-X65QQ@mail.gmail.com>
	<201210021152.30099.arnd@arndb.de>
Date: Tue, 2 Oct 2012 14:57:08 +0200
Message-ID: <CACRpkdbC_59OZhA2h4w5=5+iWd5j=xVr2yiDfYmYV5h=0cYLWw@mail.gmail.com>
Subject: Re: [PATCH 11/12] pinctrl: samsung: use __devinit section for init code
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 1:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 01 October 2012, Linus Walleij wrote:
>> On Fri, Sep 28, 2012 at 11:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> > The samsung pinctrl driver has a probe function that is
>> > __devinit and that calls a lot of other functions that are
>> > marked __init, which kbuild complains about.
>> >
>> > Marking everything __devinit means that the code does not
>> > discarded when CONFIG_HOTPLUG is set, which is a little
>> > more wasteful, but also more consistent
>> >
>> > Without this patch, building exynos_defconfig results in:
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I think the Samsing pinctrl driver has landed into next from some
>> branch in ARM SoC so you probably know better than me
>> where this thing should be merged...
>>
>
> Sorry, I was too late for this one. Can you pick it up now that the
> driver is merged?

Sure I've queued it for my -rc fixes.

Thanks,
Linus Walleij
