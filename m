Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2BQSrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:47:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41678 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2BQSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:46:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.11.129 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329504360-13770-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1329504360-13770-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Fri, 17 Feb 2012 19:46:57 +0100
Message-ID: <CACRpkdZ43P1bV8vBbMmjg_SOnd9qCPYa-sJnJDv2pjV7=G9U_w@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Add comments explaining the _cansleep() WARN_ON()s
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 7:46 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> I've seen users getting very confused by the WARN_ON()s for can_sleep
> GPIOs in the atomic-safe paths, the discoverability of the non-atomic
> version of the API seems to be hampered by the fact that it's defined
> in a header file not the .c file where the warnings are.
>
> Add a couple of comments next to the warnings to help people on their
> way.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
