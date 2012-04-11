Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2DKHvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:51:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59098 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2DKHvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <1333831045-2593-1-git-send-email-grant.likely@secretlab.ca>
References: <1333831045-2593-1-git-send-email-grant.likely@secretlab.ca>
Date: Wed, 11 Apr 2012 09:51:42 +0200
Message-ID: <CACRpkdb0eVsoraoA6WnufW_dFasCiyw5Un8NY_oiZ3QQyCp2Rw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Move DT support code into drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 10:37 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> The code in drivers/of/gpio.c isn't shared by any other subsystem since it
> is all gpiolib specific.  drivers/gpio is a better place to maintain these
> functions.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
