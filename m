Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2J1TaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:30:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35316 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2J1TaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9=dL_pNFc4-a7ifuoi9rCgJT=gtCiowF9hRmragvq6fg@mail.gmail.com>
References: <CAPgLHd9=dL_pNFc4-a7ifuoi9rCgJT=gtCiowF9hRmragvq6fg@mail.gmail.com>
Date: Sun, 28 Oct 2012 20:30:05 +0100
Message-ID: <CACRpkdYzj5_S+ydAwF+uKxFDg+0ORdBHcsRmzk1Sn6EYR5gNCw@mail.gmail.com>
Subject: Re: [PATCH -next] ARM: at91: remove duplicated include from pinctrl-at91.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 4:48 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, applied to my at91 branch.

Yours,
Linus Walleij
