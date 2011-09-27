Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1I0HOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 03:14:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1I0HOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 03:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110923162643.d3505bf7.akpm@google.com>
References: <1315259762-9034-1-git-send-email-bryan.wu@canonical.com> <20110923162643.d3505bf7.akpm@google.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 27 Sep 2011 15:13:57 +0800
X-Google-Sender-Auth: EQhyJRk1oyYoKWn2oVy2c5Sumhw
Message-ID: <CAK5ve-+gJ6m0XiXPfq12KVtMw2WL17bz=MCd4_O-M24EAcHFuA@mail.gmail.com>
Subject: Re: [PATCH v2] leds: set LEDS_TRIGGERS as tristate
To: Andrew Morton <akpm@google.com>
Cc: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 7:26 AM, Andrew Morton <akpm@google.com> wrote:
> On Tue,  6 Sep 2011 05:56:02 +0800
> Bryan Wu <bryan.wu@canonical.com> wrote:
>
>> LEDS_TRIGGERS is depends on LEDS_CLASSS, which should be tristate. So
>> set it as tristate too and update header files as well.
>>
>
> Another allmodconfig failure:
>
> drivers/built-in.o: In function `led_trigger_blink':
> (.text+0x119206): undefined reference to `led_blink_set'
> drivers/built-in.o: In function `led_trigger_set':
> (.text+0x119389): undefined reference to `led_brightness_set'
>
> I *think* it will be caused by this patch.  I'll drop it and see :(
>

It requires my second patch. I will fold them together and submit it again.

Thanks a lot,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
