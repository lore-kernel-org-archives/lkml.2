Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2JLHVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 03:21:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40093 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab2JLHVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 03:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121012140416.066516d7811e2b63e3a140a0@canb.auug.org.au>
References: <20121012140416.066516d7811e2b63e3a140a0@canb.auug.org.au>
Date: Fri, 12 Oct 2012 09:21:17 +0200
Message-ID: <CACRpkdaE4VEoqo0vJh1OW_O4ZhC4D5dB7HYkCxOJ61j2LjAOEA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pinctrl tree with the tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 5:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
>
> Today's linux-next merge of the pinctrl tree got a conflict in
> arch/arm/mach-at91/at91sam9n12.c between commit f7d19b906556 ("ARM: at91:
> add clocks for I2C DT entries") from the  tree and commit 5c70cd3c7c69
> ("arm: at91: dt: at91sam9 add pinctrl support") from the pinctrl tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

With all the conflicts that suddely appeared from the at91 pinctrl
branch I'm removing that topic from my for-next branch. I get all
the same conflicts in my tree against Torvalds now too.

Jean-Christophe: there are new deps coming in from MTD etc,
could you provide a new patch set based on e.g. 3.7-rc1 as soon
as it appears and I'll pull in that instead, so I have less conflicts.

Yours,
Linus Walleij
