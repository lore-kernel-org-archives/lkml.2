Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2HNITL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:19:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59822 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2HNITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:19:09 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-3-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-3-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:19:08 +0200
Message-ID: <CACRpkdZMoisfUD_NSkVy2w-jZVUDGn0E8LmvKSWnJ0YRGZO-tQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] irqdomain: Take interrupt-parent property into
 account if specified
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> irq_find_host() currently ignores the 'interrupt-parent' property
> even if it's specified in the Device Tree. Meaning that a node can
> match to a domain in its hierarchy even if it doesn't belong to it.
> By searching for the parent first using of_irq_find_parent() we
> insist that the 'interrupt-parent' property is taken into account
> ensuring a greater chance of returning the correct domain.
>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This (with 1/8) is the right solution. Thanks, and I think
Mark may want to look at this too since I recognize he asked
you to work in this direction.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
