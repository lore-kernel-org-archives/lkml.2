Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2I3VuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 17:50:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59651 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2I3Vtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <1348993407.20815.1.camel@phoenix>
References: <1348993407.20815.1.camel@phoenix>
Date: Sun, 30 Sep 2012 23:49:49 +0200
Message-ID: <CACRpkdaHdU4i+Jv-k1nHhXcXiuw-VVvyKeu3FnYOhF9ejEYMHg@mail.gmail.com>
Subject: Re: [PATCH] gpio: mvebu: Add missing breaks in mvebu_gpio_irq_set_type
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 10:23 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Since this gpio-mvebu patch is in ARM SoC or somewhere I expect
whoever put it there to safeguide the fix to its destination.

Else poke me after 3.7-rc1 and I'll take it as a GPIO fix...

Yours,
Linus Walleij
