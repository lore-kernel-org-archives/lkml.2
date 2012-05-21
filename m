Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2EUKnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:43:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2EUKnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <1337481215.7204.4.camel@phoenix>
References: <1337481021.7204.1.camel@phoenix>
	<1337481215.7204.4.camel@phoenix>
Date: Mon, 21 May 2012 12:43:16 +0200
Message-ID: <CACRpkda7BdaJsDdfaWXW466Yi687EAms5MAmZySVQ_xrAZNoXA@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT 3/7] regulator: ab8500: Use regulator_list_voltage_table()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 4:33 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab8500.c |   64 ++++++++++++++++---------------------------

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Hm, probably also already applied, whatever.

Yours,
Linus Walleij
