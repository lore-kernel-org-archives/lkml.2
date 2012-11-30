Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2K3LRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:17:54 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38913 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2K3LRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:17:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] GPIO patch stack for v3.8
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
In-Reply-To: <CACRpkdYDbfJO+RxbRpBmMi=mCj2L8a1rNgJgFW9EsxTPw2ivsA@mail.gmail.com>
References: <CACRpkdYDbfJO+RxbRpBmMi=mCj2L8a1rNgJgFW9EsxTPw2ivsA@mail.gmail.com>
Date: Fri, 30 Nov 2012 11:17:48 +0000
Message-Id: <20121130111748.B872E3E14C4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 10:30:27 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> Hi Grant,
> 
> to avoid any mess during the v3.8 merge window, could you please pull
> this patch stack to your GPIO branch for v3.8?
> 
> All these patches have been resting in linux-next and are reviewed and
> ACKed by maintainers. A more verbose description is in the signed
> tag.
> 
> Some confusion stems from the fact that I applied my own patches
> without replying to myself that I applied them ... split personality/role
> problem. If you pull this in, things should be more clear on what's
> queued and not - everything is in your tree.
> 
> Note that ARM SoC is already using parts of this tree as baseline
> for stuff in their tree so rebasing this patch trail is *not*
> recommended.

Don't worry, I won't rebase anything that I grab out of your tree.

> Please pull it in!
> 
> Apart from this there are a few gpiolib patches in the pinctrl tree as
> well. Those are about adding the GPIOchip local GPIO numberspace
> to pinctrl local numberspace ranges as we discussed with Dong
> Aisheng in Hong Kong, I'd be happy to brief you on the implementation
> if need be. It's also detailed here:
> https://blueprints.launchpad.net/linux-linaro/+spec/pinctrl-gpiorange-makeover

Those are fine.

g.

