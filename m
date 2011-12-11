Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1LKTgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 14:36:31 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14530 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1LKTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 14:36:28 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/gBi6c5Yhop9W8dxSvCLJo
Date: Sun, 11 Dec 2011 11:36:25 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
Message-ID: <20111211193625.GE31337@atomide.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
 <1323382390-14892-2-git-send-email-swarren@nvidia.com>
 <CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
 <20111209170722.GO31337@atomide.com>
 <CACRpkdaco=967cKHUcj9VNKc_HyT7Mw30Z9HVdfgsUsHbps8bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaco=967cKHUcj9VNKc_HyT7Mw30Z9HVdfgsUsHbps8bQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [111209 15:17]:
> On Fri, Dec 9, 2011 at 6:07 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > - We currently have hard time supporting pin groups with pins
> >  coming from multiple pinmux driver instances
> 
> Pin groups are per definiton per-controller inctance. That is a
> given side effect of not having a global pin space.
> 
> But you can create two groups of the same name on two
> pin controllers so that e.g. pinctrl.0 and pinctrl.1 have
> a group named "foo", then map both to a certain device
> in the board pinmux map.
> 
> You will have to request them individually however, like
> with two hogs or two pinmux_get() calls specifying the
> name of each map, else you will just get the first one.
> 
> Not that I've tried it, but that's how it's supposed to work...

Yes a little bit of trickery is needed there, I'll look into
it more as we already have two controller instances on omap4.

Regards,

Tony
