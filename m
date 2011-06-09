Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1FIJNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:13:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56898 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1FIJNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <1307602821.9501.1.camel@phoenix>
References: <1307602821.9501.1.camel@phoenix>
Date: Thu, 9 Jun 2011 11:13:09 +0200
Message-ID: <BANLkTimr50g_4NnrzcHcZdwkiLOtgFLgyQ@mail.gmail.com>
Subject: Re: [linux-next] drivers/gpio/gpio-nomadik.c build error
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Prafulla WADASKAR <prafulla.wadaskar@st.com>,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 9:00 AM, Axel Lin <axel.lin@gmail.com> wrote:

> make nhk8815_defconfig  with below build error:
>
>  CC      drivers/gpio/gpio-nomadik.o
> drivers/gpio/gpio-nomadik.c: In function 'nmk_gpio_wakeups_suspend':
> drivers/gpio/gpio-nomadik.c:904: error: implicit declaration of function 'cpu_is_u8500v2'
> make[2]: *** [drivers/gpio/gpio-nomadik.o] Error 1
> make[1]: *** [drivers/gpio] Error 2
> make: *** [drivers] Error 2

BTW: Grant et al, the subject says [linux-next] but the thing actually
does compile
in linux-next, since my patch is in there. This error is on Torvalds v3.0-rc2.

Thanks,
Linus Walleij
