Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2JAALm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:11:42 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:28287 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214Ab2JAALl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:11:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+RtkXxtBjyDUaTktrrv60f0BVI4IZpiN4=
Date: Sun, 30 Sep 2012 20:11:33 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: mvebu: Add missing breaks in
 mvebu_gpio_irq_set_type
Message-ID: <20121001001133.GH17765@titan.lakedaemon.net>
References: <1348993407.20815.1.camel@phoenix>
 <CACRpkdaHdU4i+Jv-k1nHhXcXiuw-VVvyKeu3FnYOhF9ejEYMHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaHdU4i+Jv-k1nHhXcXiuw-VVvyKeu3FnYOhF9ejEYMHg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 11:49:49PM +0200, Linus Walleij wrote:
> On Sun, Sep 30, 2012 at 10:23 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Since this gpio-mvebu patch is in ARM SoC or somewhere I expect
> whoever put it there to safeguide the fix to its destination.

yep, I got it.

thx,

Jason.
