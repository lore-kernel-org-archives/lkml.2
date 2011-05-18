Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1ERWZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:25:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61914 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1ERWZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JSRVhAhmyEKj2d8/ElKrgI6GDVGiVAPYRAu9OB5mf7K9bJtWTNffwSj8XGJpo/oeJU
         6oxJ/CT87kU3oHLI0rMWhGZm8ypOJHvPCbWE04NuACuqd78ySMMHfND8h+h/lzXOot0W
         Ha2Wc/H3pqvTevi0DgskjFC1TK3EVa8zc2W+g=
MIME-Version: 1.0
In-Reply-To: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Date: Thu, 19 May 2011 00:25:46 +0200
X-Google-Sender-Auth: YhLfcPaSSci9zVU6mTEj-1zbcZs
Message-ID: <BANLkTik9DuMG0veSiakyJoW+bv7gDgrCiA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Move Qualcomm gpio drivers into drivers dir
From: Linus Walleij <linus.walleij@linaro.org>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 David Brown <davidb@codeaurora.org>:

> This patch series moves the Qualcomm MSM gpio device drivers into the
> drivers/gpio directory.

Looks like a very clean cut and simple drivers that judt do plain GPIO.
FWIW Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
