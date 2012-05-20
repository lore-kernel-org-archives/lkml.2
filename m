Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2ETVN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:13:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62749 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2ETVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <1337231178.22713.2.camel@phoenix>
References: <1337231178.22713.2.camel@phoenix>
Date: Sun, 20 May 2012 23:13:26 +0200
Message-ID: <CACRpkdbN27Bf-VKXkV=wcUmRpQau=m_hDhn4khJ3cnLCxEdWoA@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT] regulator: ab3100: Use regulator_map_voltage_iterate()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 7:06 AM, Axel Lin <axel.lin@gmail.com> wrote:

> regulator_map_voltage_iterate() is for drivers implementing set_voltage_sel()
> and list_voltage() to use it as their map_voltage() operation.
>
> In this case, regulator_map_voltage_iterate() happen to be doing the same thing
> as ab3100_get_best_voltage_index() function. So we can use it to replace
> ab3100_get_best_voltage_index() function.
>
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I think Mark already applied it too, great!

Linus Walleij
