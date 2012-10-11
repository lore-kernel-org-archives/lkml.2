Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab2JKOAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:00:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58993 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2JKOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_XnZU_E3zso2F1y1GFYHewrGUSSSf8yG9LRjVkbpGL=w@mail.gmail.com>
References: <CAPgLHd_XnZU_E3zso2F1y1GFYHewrGUSSSf8yG9LRjVkbpGL=w@mail.gmail.com>
Date: Thu, 11 Oct 2012 16:00:35 +0200
Message-ID: <CACRpkdYxSRAVjsKyYwMDvZ7qGW1zBBQn4SwfEV-GGGPc=ukayw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: remove duplicated include from pinctrl-xway.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, John Crispin <blogic@openwrt.org>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 2:59 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied to my fixes branch, unless John C has objections, I'll
keep it there.

Thanks!
Linus Walleij
