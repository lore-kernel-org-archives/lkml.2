Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2EUQGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:06:50 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34557 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2EUQGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <1337481453.7204.8.camel@phoenix>
References: <1337481021.7204.1.camel@phoenix>
	<1337481453.7204.8.camel@phoenix>
Date: Mon, 21 May 2012 18:06:48 +0200
Message-ID: <CACRpkdbXQ_zZD_2qaezU3BkVgOaoq67XoVF3B5GaJVo-UWmp6Q@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT 6/7] regulator: tps6105x: Use regulator_list_voltage_table()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 4:37 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps6105x-regulator.c |   14 +++-----------
>  1 files changed, 3 insertions(+), 11 deletions(-)

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
