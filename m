Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1H2NS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:18:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35958 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1H2NSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda6-8dxSbF12N-Q32cOpogu-ZZmTApnvNBa03iOcEeqaQ@mail.gmail.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com> <CACRpkda6-8dxSbF12N-Q32cOpogu-ZZmTApnvNBa03iOcEeqaQ@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 29 Aug 2011 21:18:29 +0800
X-Google-Sender-Auth: 5Y7LCWq9My73_yhAVQ_RMaUsHGQ
Message-ID: <CAK5ve-JM=01vTqSi59R6ASyGU_2fVXzKtjNh42LKeF2HF3NzSA@mail.gmail.com>
Subject: Re: [PATCH v4 00/18] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, arnd@arndb.de, tony@atomide.com,
        jochen@scram.de, linux-kernel@vger.kernel.org, jamie@jamieiles.com,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 7:00 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Aug 26, 2011 at 11:03 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
>
>> Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
>> new generic led trigger for CPU not only for ARM but also for others.
>
> I think Russell was pretty clear that he saw problems inside the "new LEDs"
> subsystem (drivers/leds) that need be fixed before we migrate this support
> to use the LED class devices.
>
> Can you see if you can address his comment on the earlier realview patch,
> i.e. this:
> http://marc.info/?l=linux-arm-kernel&m=131237280009775&w=2
>

Yeah, I replied that email with a patch to select LEDS_CLASS when
CONFIG_NEW_LEDS=y.

But you know, there is no comments about that.

> rpurdie: your comments on the state of the LEDs class?
>
> If I get time I will attempt to fix it, no clue when that will be though.
>

Thanks a lot, I think our ledtrig-cpu patches are quite good for
merging, although Russell has some concern about leds subsystem.

Regards,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
