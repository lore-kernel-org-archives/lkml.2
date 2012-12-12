Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2LLTbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:31:36 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52183 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab2LLTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:31:35 -0500
MIME-Version: 1.0
In-Reply-To: <50C7A194.7070102@wwwdotorg.org>
References: <1355234393-17368-1-git-send-email-linus.walleij@stericsson.com>
	<50C7A194.7070102@wwwdotorg.org>
Date: Wed, 12 Dec 2012 20:31:33 +0100
Message-ID: <CACRpkdak+f8Nnyns+jdGsxrzD1839-kdOqySChD9aDG+7KMU7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: add sleep mode management for hogs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Julien Delacou <julien.delacou@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:11 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Since I assume those function are only supposed to be used by pinctrl
> drivers themselves, should the prototypes go into drivers/pinctrl/core.h
> or similar, rather than something in include/linux/pinctrl?

Good point, Julien can you fix this?

Hm, maybe pinctrl_force_sleep()/default() isn't such a good name,
maybe it should be pinctrl_hogs_sleep()/pinctrl_hogs_default() intead?

> Oh, and don't you need EXPORT_SYMBOL in case the pinctrl driver is a module?

True.

> Aside from that,
>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks.

Yours,
Linus Walleij
