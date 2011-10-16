Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1JPK5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 06:57:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43636 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1JPK5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 06:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <20111015204129.GZ21648@n2100.arm.linux.org.uk>
References: <1316508132-20020-1-git-send-email-linus.walleij@stericsson.com>
	<20111015181808.GA3128@mwesterb-mobl.ger.corp.intel.com>
	<20111015204129.GZ21648@n2100.arm.linux.org.uk>
Date: Sun, 16 Oct 2011 12:57:46 +0200
X-Google-Sender-Auth: 293dKn1qyfCOO_LsG2HywOGd9Lc
Message-ID: <CAKnu2MqHvKLs3eER8Qvof5a3F95ooabXBUAjNgsdd0xXXajhqA@mail.gmail.com>
Subject: Re: [PATCH v2] mach-ep93xx: break out GPIO driver specifics
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@iki.fi>, Ryan Mallon <rmallon@gmail.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/15 Russell King - ARM Linux <linux@arm.linux.org.uk>:

> However, as I had to use GNU patch to apply Linus' patch (as git apply
> wouldn't because of fuzz), it doesn't understand that, so it removed it.
> This is where having an /* empty */ comment avoids that kind of thing,
> just like I've done for all the other mach/gpio.h which became empty.

OK now I understand what happened, I'll have the /* empty */ comment
in them from now on...

Thanks,
Linus Walleij
