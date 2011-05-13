Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab1EMOyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:54:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65285 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1EMOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=M+M8yAcoDCKWBRoR/kwrNWUJHweLbG7Wi5mn43NB1oH2KEFbP0ecAwhLuS6CtgB+o9
         R3e8QXxcoUVFYh5bf4L2dgYhiC70UTO3HudKrsZT0zkC2et8DcuxHKMq0560Zrn3UfEq
         6lDf0PPH6Pr0D8ebVZ8LB+F9H/YAlNZe3RwPk=
MIME-Version: 1.0
In-Reply-To: <1303973940-13296-1-git-send-email-linus.walleij@stericsson.com>
References: <1303973940-13296-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 13 May 2011 16:54:42 +0200
X-Google-Sender-Auth: ChGaSGsi5AAThXMbBza0Ii0cTFk
Message-ID: <BANLkTi==T3MGumCAhrEyf4ipZo80eNiciA@mail.gmail.com>
Subject: Re: [PATCH] gpio: rename VIA local config struct
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/28 Linus Walleij <linus.walleij@stericsson.com>:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> The local VIA GPIO config struct "gpio_config" collides with my
> extension to the gpio_chip struct, so rename it to via_gpio_config
> so we don't get this clash.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Even if we're not merging anything like my configuration API for
2.6.40 IMHO this patch makes sense anyway, so please consider
applying it for bringing clarity to the source code.

Yours,
Linus Walleij
