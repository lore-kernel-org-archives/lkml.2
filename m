Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2IRVRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:17:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40182 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab2IRVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:17:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-ScAsYQnag6ix7En+XCmEmatw8S2+w-ih9uqUdv1fqXQ@mail.gmail.com>
References: <CAPgLHd-ScAsYQnag6ix7En+XCmEmatw8S2+w-ih9uqUdv1fqXQ@mail.gmail.com>
Date: Tue, 18 Sep 2012 23:17:41 +0200
Message-ID: <CACRpkdZLCeWWprpZX=F+DS2GT=Q8Bh3TwR-DzXsFN88XZe9k+Q@mail.gmail.com>
Subject: Re: [PATCH] gpio_msm: using for_each_set_bit to simplify the code
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
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

Applied with David's ACK, thanks!
Linus Walleij
