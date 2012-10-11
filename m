Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab2JKVbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:31:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34641 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263Ab2JKVa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6417685E@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F6417685E@DQHE02.ent.ti.com>
Date: Thu, 11 Oct 2012 23:30:55 +0200
Message-ID: <CACRpkdZsjnLH6RGtu2dcfvgMC81_ss=2y64M-04Zn=Gu2SVmpw@mail.gmail.com>
Subject: Re: [PATCH 25/28] leds-lp5521/5523: use new lp55xx common header
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 10:24 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

>  The LP55xx common driver provides a new header, leds-lp55xx.h.
>  This driver enables removing duplicate code for both drivers and
>  making coherent driver structure.
>  LP5521 and LP5523/55231 platform data were merged into one common file.
>  Therefore, the LP5521/5523 platform code need to be fixed.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

ux500 parts look OK, so
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
