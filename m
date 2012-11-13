Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2KMOOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:14:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44526 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2KMOOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:14:46 -0500
MIME-Version: 1.0
In-Reply-To: <1352701807.15066.1.camel@phoenix>
References: <1352701807.15066.1.camel@phoenix>
Date: Tue, 13 Nov 2012 15:14:44 +0100
Message-ID: <CACRpkdaqFB1pajpW+_+ayw++pXR=tcAx6jFLhw0BFheeAzUpmg@mail.gmail.com>
Subject: Re: [PATCH] ARM: select PINCTRL for ARCH_MMP
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 7:30 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This makes PINCTRL related config options visible.
> Otherwise there is no way to build pinctrl drivers for MMP2, PXA168 and PXA910.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Hm weird that it's not there already,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

If I get some subsystem maintainers ACK I can apply it
to the pinctrl tree.

Yours,
Linus Walleij
