Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2GFHBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:01:09 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45644 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2GFHBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120706161455.dd899154fbc8a79ee530572f@canb.auug.org.au>
References: <20120706161455.dd899154fbc8a79ee530572f@canb.auug.org.au>
Date: Fri, 6 Jul 2012 09:01:05 +0200
Message-ID: <CACRpkdbZddOBf0PXFJjr_aRD3TEa9hSvXjAjf3--8Ko_W0zZcg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the gpio-lw tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 8:14 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the gpio-lw tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> ERROR: "irq_set_chip_and_handler_name" [drivers/gpio/gpio-pcf857x.ko] undefined!
> ERROR: "dummy_irq_chip" [drivers/gpio/gpio-pcf857x.ko] undefined!

Thanks, I've dropped the offending patch, Kuninori can you look into this and
provide a new patch? It's the second patch from your patch set.

Yours,
Linus Walleij
