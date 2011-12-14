Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1LNPiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:38:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42180 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab1LNPiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <1323874795-2488-10-git-send-email-sjur.brandeland@stericsson.com>
References: <1323874795-2488-1-git-send-email-sjur.brandeland@stericsson.com>
	<1323874795-2488-10-git-send-email-sjur.brandeland@stericsson.com>
Date: Wed, 14 Dec 2011 16:38:01 +0100
Message-ID: <CACRpkdY-6PT4OpML_S2W2ag90b0AM1XxUq6dDKd18NSCa+agTw@mail.gmail.com>
Subject: Re: [PATCHv3 09/10] xshm: Makefile and Kconfig for M7400 Shared
 Memory Drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        sjurbren@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/14 Sjur Brændeland <sjur.brandeland@stericsson.com>:

> diff --git a/drivers/xshm/Makefile b/drivers/xshm/Makefile
> new file mode 100644
> index 0000000..001cd79
> --- /dev/null
> +++ b/drivers/xshm/Makefile
> @@ -0,0 +1,5 @@
> +obj-$(CONFIG_XSHM_BUS) += xshm_bus.o

Is this part of the patch set? I get:
make[4]: *** No rule to make target `drivers/xshm/xshm_bus.o', needed
by `drivers/xshm/built-in.o'.  Stop.
make[3]: *** [drivers/xshm] Error 2
make[3]: *** Waiting for unfinished jobs....

When I select CONFIG_XSHM for a platform here at random...

Yours,
Linus Walleij
