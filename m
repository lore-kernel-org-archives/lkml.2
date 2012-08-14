Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2HNI3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:29:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48434 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2HNI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-6-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:29:14 +0200
Message-ID: <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> +static struct irq_domain *db8500_irq_domain;

So this is a good idea.

> +int db8500_irq_get_virq(int irq);

And I'm sceptic about this business. Why isn't this physical-to virtual
mapping business confined to the core MFD driver? But enlighten me.

Yours,
Linus Walleij
