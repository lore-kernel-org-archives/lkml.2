Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2J1Tbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:31:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64556 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2J1Tbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:31:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8V+pcvfhCnkjmc=oteRaav4p97Jiyd7NRJPQ1DCF+QhQ@mail.gmail.com>
References: <CAPgLHd8V+pcvfhCnkjmc=oteRaav4p97Jiyd7NRJPQ1DCF+QhQ@mail.gmail.com>
Date: Sun, 28 Oct 2012 20:31:36 +0100
Message-ID: <CACRpkdZvTHXkWk4gKZZ0opt2oSpBY7OFbfpKNsf_EpNk-aodcA@mail.gmail.com>
Subject: Re: [PATCH -next] ARM: at91: using for_each_set_bit to simplify the code
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

On Fri, Oct 26, 2012 at 4:50 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using for_each_set_bit() to simplify the code.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks patch applied to my AT91 branch.

Yours,
Linus Walleij
