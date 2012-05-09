Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab2EIJJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:09:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50505 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab2EIJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120504150342.GI5140@atomide.com>
References: <20120502172401.GG3739@atomide.com>
	<20120503065131.GA3738@game.jcrosoft.org>
	<20120503152708.GC5140@atomide.com>
	<4FA30805.5050804@wwwdotorg.org>
	<20120504044305.GD7788@game.jcrosoft.org>
	<20120504150342.GI5140@atomide.com>
Date: Wed, 9 May 2012 11:09:34 +0200
Message-ID: <CACRpkdaCg7Ocy1wzdZt1x4VrnV1JrmHkLLwF4vV6GvMjXP3BjA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that supports
 omap2+ padconf
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 5:03 PM, Tony Lindgren <tony@atomide.com> wrote:

> Also I think we should let the pinctrl
> core eventually manage the pins more too. Right now the pins are
> a static array in the driver, which makes things unnecessarily
> complex for the DT case. It would be nice to also have something like
> pinctrl_register/unregister_pin instead of requiring them all
> be registered while registering with the framework initially.

Not instead of but in addition to :-)

One does not exclude the other. But a good general idea if you need
this, just introduce it.

Yours,
Linus Walleij
