Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2H1AZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 20:25:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54793 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2H1AZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 20:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <1345996865-32082-14-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-14-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 27 Aug 2012 17:25:51 -0700
Message-ID: <CACRpkdYm9kOSD_czm8Co1cXybzkPXRLHkPH5auN-fPhcBBs0gw@mail.gmail.com>
Subject: Re: [PATCH 13/13] drivers/rtc/rtc-coh901331.c: use clk_prepare_enable
 and clk_disable_unprepare
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 9:01 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> I'm not sure about this.  Maybe it would be better to leave the disable and
> unprepare separated, since there is no matching nearby clk_prepare.

This is OK.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
