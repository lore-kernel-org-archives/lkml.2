Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab0ICTis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 15:38:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35383 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab0ICTir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 15:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Z1LGs+INGp4fwrYewet1oeRATFgcSwk2daPNu2sz23G9o7yjvhxhmjGgT1mj74yNx+
         h0nAhZOuSQOEXQE/Ry83/ImZZRK77+aOTDew+6DrYa5+RZ27OCWBx5oTUwNf59ydR6JN
         2iPUGlr7I7oN8DKlJC2AeRyZW3B19Q4ky5A+Q=
MIME-Version: 1.0
In-Reply-To: <1283268367-3525-1-git-send-email-linus.walleij@stericsson.com>
References: <1283268367-3525-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 3 Sep 2010 21:38:45 +0200
X-Google-Sender-Auth: U6h4bP3St2ZFFAHwA88rTpwJ_Uw
Message-ID: <AANLkTik-uLMUz2g2znaF0K43D8CONsGdjrRqxTCqpS_X@mail.gmail.com>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v2
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/31 Linus Walleij <linus.walleij@stericsson.com>:

> After discovering a problem in regulator reference counting I
> took Mark Brown's advice to move the reference count into the
> MMC core by making the regulator status a member of
> struct mmc_host.

This has an Reveiwed-by from the regulator maintainer and
seems to address all comments, noone is objection so Andrew
can you pick it up?

Yours,
Linus Walleij
