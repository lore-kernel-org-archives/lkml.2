Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2ELOyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 10:54:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2ELOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 10:54:04 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Bryan Wu <bryan.wu@canonical.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and consolidate LED driver in ARM
Date: Sat, 12 May 2012 14:53:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, tim.gardner@canonical.com
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com> <alpine.LFD.2.02.1205101351380.21030@xanadu.home> <CAK5ve-L4rcAx-=n5u7G0AQzvUG3ir_jzF_ibaSf-EntXAzFUCw@mail.gmail.com>
In-Reply-To: <CAK5ve-L4rcAx-=n5u7G0AQzvUG3ir_jzF_ibaSf-EntXAzFUCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205121453.45242.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:0XvtdL+rAryCPzw6T8LfouprCT9Q9K97HjEJseLdBTV
 XRacKugmtMU1ME+tEHhBCBUsjgEB8pw1XacjTg6OHr69jKa3Ir
 vMns6uVJ3jcK9aCSaccFQXyI0WgM2uBH6zcRmXFMnpG8w9TT2Q
 /Z3iNCF2xa2u7HmOwmz5HHV/3cYMn7p9NEzIaWwfxV+FghXkke
 N/FnVXKphMmVimOLCwb0go1aWeF4Cjy4ZZD6AEsR3qCjOOBWQp
 D17a4ZsKfmuMphGVOz7+CCVg5ktUeB3VTc2TVfInPOaYqQc0fm
 rwFGC7mXIB6dYDarWN5RuqH+A/2W/6uLIP9IT5No/SxJCQNHqY
 8X8jaLXfUWi8SQHYI5MzKSqLQOkircZXJtGcV3cnW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012, Bryan Wu wrote:
> OK, I rebased my patch back on 3.4.0-rc6, please find it here:
> git://kernel.ubuntu.com/roc/linux-2.6/.git leds
> 
> linux-next branch can be also found here:
> git://kernel.ubuntu.com/roc/linux-2.6/.git leds-next
> 
> Arnd, could you please help me to merge? if got any issue, please
> point to me to fix.
> 

Hi Bryan,

I've merged it into a new next/leds branch. I got conflicts with the clps711x
and at91 cleanups that are already in the next/cleanup branch but I think
I resolved them all correctly.  It would be nice if you and/or the maintainers
of those platforms could confirm that.

What is the point of your leds-next branch? We usually don't have a branch like
that because the linux-next tree is rebased every day, and creating a branch based
on it will not be too helpful. Your patches should be in the next linux-next
release, so everyone can just use that for testing now.

	Arnd
