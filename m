Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2I0MsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:48:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52864 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0MsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <5064487A.5040105@gmail.com>
References: <1348679887-2135-1-git-send-email-linus.walleij@stericsson.com>
	<5064487A.5040105@gmail.com>
Date: Thu, 27 Sep 2012 14:48:11 +0200
Message-ID: <CACRpkdZ3vQ_9ZF3t=syhCx5Y_G_rrjd-3=HrJKo6xLYWAP0wPg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/nomadik: allocate IRQ descriptors dynamically
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 2:37 PM, Rob Herring <robherring2@gmail.com> wrote:

>>       nmk_chip->domain = irq_domain_add_legacy(np, NMK_GPIO_PER_CHIP,
>
> You might as well change to irq_domain_add_simple here.

True. I'll fix.

> Perhaps we should just add irq_alloc_descs call into
> irq_domain_add_simple in the legacy case. It may need to be conditioned
> on SPARSE_IRQ. There's currently no callers, so it wouldn't break anything.

OK get ready to ACK, I'll fix.

Yours,
Linus Walleij
