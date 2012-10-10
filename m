Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab2JJGqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:46:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59051 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JJGqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8F99f5LVS-wNekKA+a1369RfqCa-w_jHGV-_Wueg_cTQ@mail.gmail.com>
References: <CAPgLHd8F99f5LVS-wNekKA+a1369RfqCa-w_jHGV-_Wueg_cTQ@mail.gmail.com>
Date: Wed, 10 Oct 2012 08:46:33 +0200
Message-ID: <CACRpkdY5F1zd0Qh1jvintMn6R35_ZAaTUkbRxaK5tnvy=_Q8ig@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix return value in bcm2835_pinctrl_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: swarren@wwwdotorg.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-rpi-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 4:01 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function pinctrl_register() returns
> NULL not ERR_PTR(). The PTR_ERR() in the return value
> should be replaced with error no.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied with Stephen's ACK.

Thanks!
Linus Walleij
