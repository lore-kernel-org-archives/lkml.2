Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1EBTkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:40:36 -0400
Received: from mail.perches.com ([173.55.12.10]:1126 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab1EBTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:40:35 -0400
Subject: Re: [PATCH 2/4] pinmux: add a driver for the U300 pinmux
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
References: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 12:40:33 -0700
Message-ID: <1304365233.7792.42.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
[]
> diff --git a/drivers/pinmux/pinmux-u300.c b/drivers/pinmux/pinmux-u300.c
> +++ b/drivers/pinmux/pinmux-u300.c
> +struct u300_pin_desc {
> +	unsigned number;
> +	char *name;

const char *name?


