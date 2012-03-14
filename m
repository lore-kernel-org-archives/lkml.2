Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab2CNJBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:01:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43684 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495Ab2CNJBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120313161138.cbeb594d.akpm@linux-foundation.org>
References: <1331197863-25564-1-git-send-email-bryan.wu@canonical.com>
	<1331197863-25564-3-git-send-email-bryan.wu@canonical.com>
	<20120313161138.cbeb594d.akpm@linux-foundation.org>
Date: Wed, 14 Mar 2012 10:01:00 +0100
Message-ID: <CACRpkdYMgRsJaKSNhChWvZGj497pgGYWTh26oSCXSYjYr8_JxA@mail.gmail.com>
Subject: Re: [PATCH 3/3] led-triggers: create a trigger for CPU activity
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <bryan.wu@canonical.com>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 12:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu,  8 Mar 2012 17:11:03 +0800
> Bryan Wu <bryan.wu@canonical.com> wrote:
>
>> Attempting to consolidate the ARM LED code, this removes the
>> custom RealView LED trigger code to turn LEDs on and off in
>> response to CPU activity and replace it with a standard trigger.
>>
>> (bryan.wu@canonical.com:
>> It moves arch/arm/kernel/leds.c syscore stubs into this trigger.
>> It also provides ledtrig_cpu trigger event stub in <linux/leds.h>.
>> Although it was inspired by ARM work, it can be used in other arch.)
>
> The patch doesn't "remove" or "move" anything.  It wholly consists of
> additions.  Confused.
>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
>> Tested-by: Jochen Friedrich <jochen@scram.de>
>
> The authorship is a bit unclear.  You're the primary author, yes?

It's based on a patch I wrote ages ago, but I don't care much.
Since Bryan's been driving it since, let's say Bryan wrote it.
Just remove the signoff if it's confusing.

Linus Walleij
