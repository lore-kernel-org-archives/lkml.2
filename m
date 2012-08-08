Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220Ab2HHJ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:59:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36691 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab2HHJ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:59:31 -0400
Date: Wed, 8 Aug 2012 10:59:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120808095928.GI16861@opensource.wolfsonmicro.com>
References: <20120807170333.GV16861@opensource.wolfsonmicro.com>
 <20120808080411.GB4728@gmail.com>
 <201208080828.35451.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208080828.35451.arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 08:28:35AM +0000, Arnd Bergmann wrote:

> In general, it seems easier to use the same domain type for both cases.
> I don't think that MOP500_AB8500_VIR_GPIO_IRQ_BASE is used anywhere
> else besides the .irq_base definition in board-mop500.c, so I would guess
> that you can just remove that identifier and always use the linear
> domain.

Given how easy this is to get working it doesn't seem sensible to avoid
it - there's a clear pattern already for maintaining support for legacy
domains.
