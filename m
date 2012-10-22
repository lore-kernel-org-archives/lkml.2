Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2JVJEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:04:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49908 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JVJE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_ogKwOa26a3jLGGMDOTNLemD+xynzWK87-YyvQ2Zm0VA@mail.gmail.com>
References: <CAPgLHd_ogKwOa26a3jLGGMDOTNLemD+xynzWK87-YyvQ2Zm0VA@mail.gmail.com>
Date: Mon, 22 Oct 2012 11:04:28 +0200
Message-ID: <CACRpkdbh0-hmBOo4bCKQ4jjvppV7WMkUxOp=6-6e=LmaVdRTdA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix missing unlock on error in pinctrl_groups_show()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 6:58 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing unlock on the error handle path in function
> pinctrl_groups_show().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks Wei, add to my fixes branch with an @stable tag.

Yours,
Linus Walleij
