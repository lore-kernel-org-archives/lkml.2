Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2IKRtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:49:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49036 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2IKRtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:49:31 -0400
MIME-Version: 1.0
In-Reply-To: <002b01cd8fee$2195b460$64c11d20$%han@samsung.com>
References: <002b01cd8fee$2195b460$64c11d20$%han@samsung.com>
Date: Tue, 11 Sep 2012 19:49:30 +0200
Message-ID: <CACRpkdZ_zac1KPX8qJ-hGS=A9WFS8ZO=db9YiLxhpQ3AxBwyaA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: samsung: use pr_* instead of printk
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Ryan Mallon <rmallon@gmail.com>, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 9:21 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses pr_* instead of printk. Also, gpio_dbg
> is replaced with pr_debug.
>
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

This looks good to me,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Kukjin/Ben can I have an ACK on this patch, or do you prefer to merge
it into the Samsung tree?

Yours,
Linus Walleij
