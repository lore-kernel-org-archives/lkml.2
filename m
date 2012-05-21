Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab2EUJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:16:59 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35564 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab2EUJQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <1337481118.7204.3.camel@phoenix>
References: <1337481021.7204.1.camel@phoenix>
	<1337481118.7204.3.camel@phoenix>
Date: Mon, 21 May 2012 11:16:57 +0200
Message-ID: <CACRpkdaQ+yo2WbrqG0wvBg0LoBzr3TECHqgQpJYAzOKRAj4Z+Q@mail.gmail.com>
Subject: Re: [PATCH RFC/RFT 2/7] regulator: ab3100: Use regulator_list_voltage_table()
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

On Sun, May 20, 2012 at 4:31 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab3100.c |   50 ++++++++++++-------------------------------
>  1 files changed, 14 insertions(+), 36 deletions(-)

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
