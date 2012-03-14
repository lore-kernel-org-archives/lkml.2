Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257Ab2CNR3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:29:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42425 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761202Ab2CNR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:28:58 -0400
Date: Wed, 14 Mar 2012 10:29:00 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/3] pinctrl: allow concurrent gpio and mux function
 ownership of pins
Message-ID: <20120314172900.GB14853@quad.lixom.net>
References: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
 <1330993336-9538-2-git-send-email-swarren@nvidia.com>
 <CACRpkdYdSaNsrr34o2Cc4vS12ee9oY7FG0pxB92mefHZKwdEpA@mail.gmail.com>
 <4F5E3F63.5080506@wwwdotorg.org>
 <CACRpkdYsD2LCNoox6ztHTP76X8a_qxjiZFO4ou=BgZ4oE0qHtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYsD2LCNoox6ztHTP76X8a_qxjiZFO4ou=BgZ4oE0qHtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:42:48PM +0100, Linus Walleij wrote:
> On Mon, Mar 12, 2012 at 7:24 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > Linus, now that Grant has ack'd and applied the documentation change
> > behind this, could you take this one patch into the pinctrl tree.
> 
> Of course, applied.
> 
> > I assume it's 3.5 material.
> 
> No it goes in now, we can't have documentation that is misleading...
> Besides, I like it.

Oops, this reply didn't show before I hit reply on the other one.

Stephen, that makes things easy for you if you still need time to sort things
out on the tegra side, since 3.4-rc1 can be the base for that work.


-Olof
