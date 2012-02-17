Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2BQSlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:41:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44691 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2BQSle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:41:34 -0500
MIME-Version: 1.0
In-Reply-To: <1329503041-11517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1329503041-11517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Fri, 17 Feb 2012 19:41:33 +0100
Message-ID: <CACRpkdYuBpeKSe3HtWW8Nu=z-tnOTCCCkjvbnf8uu_udJ8Matw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Add comments explaining the _cansleep() WARN_ON()s
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 7:24 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> I've seen users getting very confused by the WARN_ON()s for can_sleep
> GPIOs in the atomic-safe paths, the discoverability of the non-atomic
> version of the API seems to be hampered by the fact that it's defined
> in a header file not the .c file where the warnings are.
>
> Add a couple of comments next to the warnings to help people on their
> way.

Good!

> +       /* Should be using gpio_get_value_cansleep() or a different GPIO */
>        WARN_ON(chip->can_sleep);

Actually I cannot parse the "or a different GPIO" part.

If this means that the user may be addressing the wrong GPIO pin,
then we could spell that out I presume, but maybe you are referring
to something else?

Yours,
Linus Walleij
