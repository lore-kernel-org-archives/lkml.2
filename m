Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2HFPTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:19:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56492 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2HFPTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:19:33 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1344265900-17726-1-git-send-email-linus.walleij@stericsson.com>
References: <1344265900-17726-1-git-send-email-linus.walleij@stericsson.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 6 Aug 2012 23:19:13 +0800
Message-ID: <CAF+7xWmjsnQ68DG=HJHY6CEqupFq6oGCa7e-JZWn=JqGscAYrA@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab3100: add missing voltage table
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/6 Linus Walleij <linus.walleij@stericsson.com>:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> The conversion to voltage tables in
>
> commit a3beb74261f26142019847128b2441b0301797ac
> "regulator: ab3100: Use regulator_list_voltage_table()"
>
> missed to add the voltage table to the buck. Fix this and
> it works like a charm.
>
> Cc: Axel Lin <axel.lin@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Axel Lin <axel.lin@gmail.com>
