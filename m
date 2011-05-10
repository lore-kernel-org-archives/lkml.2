Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1EJXmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:42:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37222 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1EJXmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YdmvfIhfiYqUVma0DaRbGujSYXA3EIhl5K2d41rrvzOO8Tjo9k6cya9CNNOaecz6K7
         L4Sozkm5XU3gw0Z8YFAr7bjtZorsMokp76s9CtIIYlKjbAhhSChNFRb7CFvd98jSwrRp
         8kWbfdCZzIjywFh+E3DIZCiHLFY+qMuaCao8o=
MIME-Version: 1.0
In-Reply-To: <1305069787.19586.141.camel@Joe-Laptop>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<1304365077.7792.40.camel@Joe-Laptop>
	<BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
	<1305067020.19586.130.camel@Joe-Laptop>
	<BANLkTi=zDJLHUa2ogTeEkmdsbkhvGJCsEw@mail.gmail.com>
	<1305069787.19586.141.camel@Joe-Laptop>
Date: Wed, 11 May 2011 01:42:22 +0200
X-Google-Sender-Auth: dU-P9jLKXvD5zaYk7HRtziyYlVE
Message-ID: <BANLkTikjcJp_PK9pBNyAk-D=MbZ7cr1BPQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Convert gpio_is_valid to return bool
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/11 Joe Perches <joe@perches.com>:

> Make the code a bit more readable.
>
> Instead of casting an int to an unsigned then comparing to
> MAX_NR_GPIOS, add a >= 0 test and let the compiler optimizer
> do the conversion to unsigned.
>
> The generated code should be the same.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Joe!
Linus Walleij
