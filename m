Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2IQKys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:54:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52444 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2IQKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:54:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-ScAsYQnag6ix7En+XCmEmatw8S2+w-ih9uqUdv1fqXQ@mail.gmail.com>
References: <CAPgLHd-ScAsYQnag6ix7En+XCmEmatw8S2+w-ih9uqUdv1fqXQ@mail.gmail.com>
Date: Mon, 17 Sep 2012 12:54:45 +0200
Message-ID: <CACRpkdbnawDdmwoY5CS8Sd-ZyN0hfx8fa7gdjPmESwpsp2dCVg@mail.gmail.com>
Subject: Re: [PATCH] gpio_msm: using for_each_set_bit to simplify the code
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, David Brown <davidb@codeaurora.org>
Cc: grant.likely@secretlab.ca, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 4:28 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using for_each_set_bit() to simplify the code.
>
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

David, does this patch look OK from your point of view?

Yours,
Linus Walleij
