Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2KKSOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:14:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40842 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2KKSOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:14:34 -0500
MIME-Version: 1.0
In-Reply-To: <1352266628.7588.1.camel@phoenix>
References: <1352266628.7588.1.camel@phoenix>
Date: Sun, 11 Nov 2012 19:14:32 +0100
Message-ID: <CACRpkdZYU4osZ77=dPaCQET5XsC47D5=DW1-eYoKoKSRqaq3JA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Staticize pinconf_ops
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Simon Arlott <simon@fire.lp0.eu>, John Crispin <blogic@openwrt.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 6:37 AM, Axel Lin <axel.lin@ingics.com> wrote:

> They are not referenced outside respective driver.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Simon Arlott <simon@fire.lp0.eu>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>

OK I had to merge down all my topic branches to the devel
branch to apply this on top, but we are at -rc5 so it's about
time!

Applied with Dong's ACK.

Yours,
Linus Walleij
