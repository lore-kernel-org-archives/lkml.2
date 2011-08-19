Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1HSMqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:46:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52492 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab1HSMqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <1312913020-7508-1-git-send-email-linus.walleij@stericsson.com>
References: <1312913020-7508-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 19 Aug 2011 14:46:49 +0200
Message-ID: <CACRpkdbyjj+7Lm9JCLnYLC_z6Tt+XOr9waYjQAezRDyq7Tb=Ug@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio/nomadik: remove pull-pinconfig and add SPI2
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Fredrik Svensson <fredrik.xk.svensson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 8:03 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Fredrik Svensson <fredrik.xk.svensson@stericsson.com>
>
> Remove PIN_CFG_PULL in pincfg.h for plat-nomadik, PIN_CFG_INPUT
> already takes care of this. Added support for SPI2.
>
> Signed-off-by: Fredrik Svensson <fredrik.xk.svensson@stericsson.com>
> Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Ping on these three patches too ....

Thanks,
Linus Walleij
