Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2HNIRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:17:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38502 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab2HNIRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:17:09 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-2-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-2-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:17:08 +0200
Message-ID: <CACRpkdb2MKgaoknHcWjrQqXPr6dXRsPjDxCwzNvGahJ48wMzdA@mail.gmail.com>
Subject: Re: [PATCH 1/8] of/irq: Create stub for of_irq_find_parent when !CONFIG_OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> of_irq_find_parent is a handy function to use outside the confines of
> the Open Firmware subsystem. One such use-case is when the IRQ Domain
> wishes to find an IRQ domain for a given device node. Currently it can
> not take any notice of the 'interrupt-parent' property. Instead it
> just uses the first IRQ controller as it climbs the Device Tree. If
> we were to use this as a precursor the resultant controller is more
> likely to be correct.
>
> CC: Rob Herring <rob.herring@calxeda.com>
> CC: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This is clever.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
