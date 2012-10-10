Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2JJGrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:47:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46767 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JJGri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-C5NvpG7vo68kAjY4+CxDXenYU-Po-K4Z+uuvz_vZpxg@mail.gmail.com>
References: <CAPgLHd-C5NvpG7vo68kAjY4+CxDXenYU-Po-K4Z+uuvz_vZpxg@mail.gmail.com>
Date: Wed, 10 Oct 2012 08:47:37 +0200
Message-ID: <CACRpkdZuw06MjJdQimfzup2WddMSYL4PYk-3Q7T-T00x=fzN4w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: remove duplicated include from pinctrl-bcm2835.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: swarren@wwwdotorg.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-rpi-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 3:28 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied with Stephen's ACK.

Thanks!
Linus Walleij
