Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2J1Tdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:33:45 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47534 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2J1Tdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:33:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8wKSubYtsnSm28-5R7aJ6uKcO1K31LCJCWTnU2A8+iPA@mail.gmail.com>
References: <CAPgLHd8wKSubYtsnSm28-5R7aJ6uKcO1K31LCJCWTnU2A8+iPA@mail.gmail.com>
Date: Sun, 28 Oct 2012 20:33:42 +0100
Message-ID: <CACRpkdZOizwF85viBS+PVKRtUmcBYC8BT7ffGPHQ2p-B8Ef7+A@mail.gmail.com>
Subject: Re: [PATCH -next] ARM: at91: remove unused variable in at91_dt_node_to_map()
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

On Fri, Oct 26, 2012 at 4:54 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The variable pin is initialized but never used
> otherwise, so remove the unused variable.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, patch applied to my AT91 branch.

BTW I will change the subject from ARM: AT91 to pinctrl/at91 on
all of them.

Of future mailings please include Mr. Jean-Christophe Plaiginol-Villard
on patches to the AT91 pinctrl driver.

Yours,
Linus Walleij
