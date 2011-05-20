Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1ETUss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 16:48:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34427 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1ETUsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 16:48:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jw63/Jsx4Qbh2321UQsnMO/IFN2mVYlQjkIEFiJw4GN5O4aqO3IN0HmIb+QIg1YA6C
         iYCdFnP+7FPqN0+8mW4WYotjW5D+TbAj5SOQmfhZseUujSWrSdaWWm44o0gLMS2TPpnq
         NTYJK0Q0QdDxt17e9mXMIHrNYeqV+GUXKOXLY=
MIME-Version: 1.0
In-Reply-To: <201105181047.17309.arnd@arndb.de>
References: <201105181047.17309.arnd@arndb.de>
Date: Fri, 20 May 2011 22:48:45 +0200
X-Google-Sender-Auth: GQVzrpSL8cmZZVr-4l71CIvRWEc
Message-ID: <BANLkTin53hToQ-X8MgbtEp97ZW2OXePsKQ@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Arnd Bergmann <arnd@arndb.de>:

> Maintainers: If you are happy with the layout of the process,
> please ack this patch, otherwise please comment.
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fce5e6..942d052 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -630,6 +630,17 @@ S: Maintained
>  F:     drivers/amba/
>  F:     include/linux/amba/bus.h
>
> +ARM SUBARCHITECTURES
> +M:     Arnd Bergmann <arnd@arndb.de>
> +M:     Nicolas Pitre <nico@fluxnic.net>
> +M:     Thomas Gleixner <tglx@linutronix.de>
> +M:     arm@kernel.org
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:     MAINTAINED
> +F:     arch/arm/mach-*/
> +F:     arch/arm/plat-*/
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
