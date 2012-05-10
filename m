Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2EJWf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:35:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761678Ab2EJWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:35:56 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio/langwell: re-read the IRQ status register after each iteration
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Julia Lawall <Julia.Lawall@lip6.fr>
In-Reply-To: <CACRpkdbA58UiNLZRPWe1yGckGFrXqtJ3ddqjLLzLntC6+Cin3g@mail.gmail.com>
References: <1336644082-14137-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdbA58UiNLZRPWe1yGckGFrXqtJ3ddqjLLzLntC6+Cin3g@mail.gmail.com>
Date: Thu, 10 May 2012 16:35:54 -0600
Message-Id: <20120510223554.183F83E04A6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 14:16:56 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, May 10, 2012 at 12:01 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Spotted by Grant Likely. The IRQ status register should be re-read after
> > each iteration. Otherwise the loop misses the interrupt if it gets raised
> > immediately after handled.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > This patch applies on top of my previous patch ("gpio: langwell: convert to
> > use irq_domain").
> 
> Oh yeah that thing I recognize!
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.

