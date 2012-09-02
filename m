Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2IBSzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 14:55:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBSzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 14:55:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Date: Sun, 2 Sep 2012 18:55:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209021855.11579.arnd@arndb.de>
X-Provags-ID: V02:K0:oWZYP8YE4yDBqoUUi0XV4Kn6i8gOPI+51FTSMJoF4i1
 80DAOPaem4UqJ8DEQnIkOV2ZustTQT2euHB5QGyh9LiSuyzC1x
 2+fure6P5ygi7a/XIhKdC8ppY+fDpjhnhz9oC+zvqXc6H7kfPV
 h2km2L4tTdM0chzfzFgQHBrJ1wIbsiS+8OEEG1TAd0D59m8n1/
 qRGb8+KXVzIbLPdbu6EGmTTKhrwdRy+Lx8pGyVjZmLO1h0dnIc
 Z9ZKsqze3RMrY/XiMUM0TnCoBqVtRV6tNt60RRZQIMdJOkJokt
 Dpco99U9FbYYgdMIA66iTYexWifSDjNDYaDKV3uD7a2r/1rg+Z
 OIyl33btUKgt6iG82t2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2012, Thierry Reding wrote:
> This commit moves the driver to drivers/pwm and converts it to the new
> PWM framework.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> Note: I'll take this through the PWM tree, but I'd like to have it
> acknowledged by a few people who know the hardware and can actually
> test whether this still works.

Did you create the patch using 'git format-patch -M'? It should
show the changes as a move plus changes rather than a file remove
and another file add.

The change to the common framework is of course very welcome,

Acked-by: Arnd Bergmann <arnd@arndb.de>
