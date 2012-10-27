Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab2J0QSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:18:36 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57053 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2J0QSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:18:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8BxYammidxX_-fmQSujf2LHL44qYMEBVDLrfV2ziBKBA@mail.gmail.com>
References: <CAPgLHd8BxYammidxX_-fmQSujf2LHL44qYMEBVDLrfV2ziBKBA@mail.gmail.com>
Date: Sat, 27 Oct 2012 18:18:34 +0200
Message-ID: <CACRpkdbWfnoNQCXPu9hVy9R=NJch42XcFNW1WKGYhXdpOizyVQ@mail.gmail.com>
Subject: Re: [PATCH -next] GPIO: clps711x: use platform_device_unregister in gpio_clps711x_init()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, Alexander Shiyan <shc_work@mail.ru>
Cc: grant.likely@secretlab.ca, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 5:15 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> platform_device_unregister() only calls platform_device_del() and
> platform_device_put(), thus use platform_device_unregister() to
> simplify the code.
>
> Also the documents in platform.c shows that platform_device_del
> and platform_device_put must _only_ be externally called in error
> cases.  All other usage is a bug.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, patch applied.

Yours,
Linus Walleij
