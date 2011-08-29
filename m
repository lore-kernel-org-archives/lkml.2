Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1H2LAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:00:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54939 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1H2LAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:00:43 -0400
MIME-Version: 1.0
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Date: Mon, 29 Aug 2011 13:00:42 +0200
Message-ID: <CACRpkda6-8dxSbF12N-Q32cOpogu-ZZmTApnvNBa03iOcEeqaQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/18] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux@arm.linux.org.uk, tony@atomide.com, jochen@scram.de,
        linux@maxim.org.za, nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 11:03 AM, Bryan Wu <bryan.wu@canonical.com> wrote:

> Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
> new generic led trigger for CPU not only for ARM but also for others.

I think Russell was pretty clear that he saw problems inside the "new LEDs"
subsystem (drivers/leds) that need be fixed before we migrate this support
to use the LED class devices.

Can you see if you can address his comment on the earlier realview patch,
i.e. this:
http://marc.info/?l=linux-arm-kernel&m=131237280009775&w=2

rpurdie: your comments on the state of the LEDs class?

If I get time I will attempt to fix it, no clue when that will be though.

Thanks,
Linus Walleij
