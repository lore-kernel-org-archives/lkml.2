Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab2IAEPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 00:15:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64626 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2IAEPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 00:15:36 -0400
MIME-Version: 1.0
In-Reply-To: <1345996865-32082-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-4-git-send-email-Julia.Lawall@lip6.fr>
Date: Sat, 1 Sep 2012 06:15:35 +0200
Message-ID: <CACRpkdYgN5NhgPuKaJJNC2frL2rJ1jdo-DDPPYn1dn38wENpsg@mail.gmail.com>
Subject: Re: [PATCH 3/13] drivers/gpio/gpio-pxa.c: use clk_prepare_enable and clk_disable_unprepare
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 6:00 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.

Applied,
if your PXA people don't like it, shout.

Yours,
Linus Walleij
