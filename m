Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2EIUuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:50:14 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:20013 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2EIUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:50:12 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dS8wI/HTFvvhhnk0mwX6R
Date: Wed, 9 May 2012 13:50:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120509205009.GW5088@atomide.com>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
 <20120504150342.GI5140@atomide.com>
 <CACRpkdaCg7Ocy1wzdZt1x4VrnV1JrmHkLLwF4vV6GvMjXP3BjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaCg7Ocy1wzdZt1x4VrnV1JrmHkLLwF4vV6GvMjXP3BjA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120509 02:13]:
> On Fri, May 4, 2012 at 5:03 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > Also I think we should let the pinctrl
> > core eventually manage the pins more too. Right now the pins are
> > a static array in the driver, which makes things unnecessarily
> > complex for the DT case. It would be nice to also have something like
> > pinctrl_register/unregister_pin instead of requiring them all
> > be registered while registering with the framework initially.
> 
> Not instead of but in addition to :-)
> 
> One does not exclude the other. But a good general idea if you need
> this, just introduce it.

Sure agreed it does not exclude the other. Will take a look when
I have a chance.

Tony
