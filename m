Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab1E2Bi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 21:38:56 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39245 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1E2Biz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 21:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=tNZfOD4vJIE2Io87ExxSD3yf1tPbks94ANByTrJzPOLy1teCZKtS7XieB0Mu1JE36c
         Vo1/rhxLgLDBZ30AIaVtC4ymSHppYrurnlONB6ggrUYUokLAkgDHdEz2I5smxjvkXMcg
         R55F5l12kYuErIN7kr8LiAPJbLCcFyG1/ix0w=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110528174733.GF9907@pengutronix.de>
References: <1306576376.10669.12.camel@phoenix> <20110528174733.GF9907@pengutronix.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 29 May 2011 09:38:34 +0800
Message-ID: <BANLkTi=F2Gh=+-8ms0nBf+zdLy+7uEOugg@mail.gmail.com>
Subject: Re: [PATCH] leds: make LEDS_GPIO_REGISTER depend on NEW_LEDS
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Uwe,
> Below is a patch that fixes the layout problem but keeps the
> functionality as before and intended.
>
> -----8<-----
> leds: move LEDS_GPIO_REGISTER out of menuconfig NEW_LEDS
>
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>
> Commit 4440673a "leds: provide helper to register "leds-gpio" devices"
> broke the display of the NEW_LEDS menu as it didn't depend on NEW_LEDS
> and so made "LED drivers" and "LED Triggers" appear at the same level as
> "LED Support" instead of below it as it was before 4440673a.
>
> Moving LEDS_GPIO_REGISTER out of the menuconfig NEW_LEDS fixes this
> unintended side effect.
>
> Reported-by: Axel Lin <axel.lin@gmail.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
Your patch looks good.

Thanks,
Axel
