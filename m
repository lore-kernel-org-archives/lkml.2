Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2JSKJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:09:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53575 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab2JSKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <002801cdac0a$11e4f340$35aed9c0$%han@samsung.com>
References: <002801cdac0a$11e4f340$35aed9c0$%han@samsung.com>
Date: Fri, 19 Oct 2012 12:08:59 +0200
Message-ID: <CACRpkdYx1HLF2==6DsPp+qC6Xyb7Ag8qa1K7g2Ht-Y2T-UjzMA@mail.gmail.com>
Subject: Re: [PATCH V3] gpio: samsung: use pr_* instead of printk
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ryan Mallon <rmallon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 3:52 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses pr_* instead of printk. Also, gpio_dbg
> is replaced with pr_debug.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org> <- NAK

Please consult Documentation/SubmittingPatches as to the conditions that
apply when you add Reviewed-by tags.

Hint: it doesn't mean "I know Linus looked at this patch".

Yours,
Linus Walleij
