Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2KHVgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:36:15 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62171 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab2KHVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:36:14 -0500
MIME-Version: 1.0
In-Reply-To: <1352342822.19098.4.camel@phoenix>
References: <1352342724.19098.2.camel@phoenix>
	<1352342822.19098.4.camel@phoenix>
Date: Thu, 8 Nov 2012 22:36:11 +0100
Message-ID: <CACRpkdYZxHdikzzt8gJeWNNg_WUME2hM=Pu7WHKteDvA1Zv46g@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: tegra: Drop exporting static functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 3:47 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Both tegra_gpio_enable() and tegra_gpio_disable() are static functions, it does
> not make sense to export them.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Stephen's ACK.

Yours,
Linus Walleij
